# Lasting Ember Implementation Plan

**Timeline:** 3 weeks (Feb 10 - Mar 1, 2025)  
**Team:** Assuming 1-2 developers  
**Approach:** Build in layers, test each before moving on

---

## Development Phases

```
Week 1: Foundation    Week 2: Features    Week 3: Transactions
┌────────────────┐   ┌────────────────┐   ┌────────────────┐
│ Project Setup  │   │ Track Upload   │   │ Stripe Checkout│
│ Database       │   │ Catalog Browse │   │ License Flow   │
│ Auth           │   │ Audio Player   │   │ Downloads      │
│ R2 Storage     │   │ Artist Pages   │   │ Emails         │
│ Layouts        │   │ Connect Setup  │   │ Polish + Deploy│
└────────────────┘   └────────────────┘   └────────────────┘
```

---

## Week 1: Foundation (Feb 10-16)

### Day 1-2: Project Setup

**Initialize Next.js Project**
```bash
npx create-next-app@latest lasting-ember --typescript --tailwind --eslint --app --src-dir
cd lasting-ember

# Install core dependencies
npm install @supabase/supabase-js @supabase/ssr
npm install stripe @stripe/stripe-js
npm install @aws-sdk/client-s3 @aws-sdk/s3-request-presigner
npm install zod react-hook-form @hookform/resolvers
npm install lucide-react class-variance-authority clsx tailwind-merge
npm install wavesurfer.js

# Dev dependencies
npm install -D @types/node supabase
```

**Setup shadcn/ui**
```bash
npx shadcn-ui@latest init
npx shadcn-ui@latest add button card input label select textarea
npx shadcn-ui@latest add dialog dropdown-menu toast avatar badge
npx shadcn-ui@latest add table tabs form
```

**Create folder structure**
```
src/
├── app/
│   ├── (public)/           # Public routes
│   │   ├── catalog/
│   │   ├── track/[id]/
│   │   ├── artist/[slug]/
│   │   └── page.tsx        # Landing
│   ├── (auth)/             # Auth routes
│   │   ├── login/
│   │   ├── signup/
│   │   └── layout.tsx
│   ├── dashboard/          # Buyer portal
│   │   ├── licenses/
│   │   └── layout.tsx
│   ├── studio/             # Artist portal
│   │   ├── upload/
│   │   ├── tracks/
│   │   ├── earnings/
│   │   └── layout.tsx
│   ├── api/
│   │   ├── tracks/
│   │   ├── studio/
│   │   ├── checkout/
│   │   └── webhooks/
│   ├── layout.tsx
│   └── globals.css
├── components/
│   ├── ui/                 # shadcn components
│   ├── audio-player.tsx
│   ├── track-card.tsx
│   ├── search-filters.tsx
│   └── ...
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── middleware.ts
│   ├── stripe.ts
│   ├── r2.ts
│   └── utils.ts
├── types/
│   ├── database.types.ts   # Generated from Supabase
│   └── index.ts
└── hooks/
    └── ...
```

**Environment Variables (.env.local)**
```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Stripe
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=

# Cloudflare R2
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET_NAME=lasting-ember
R2_PUBLIC_URL=

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Day 2-3: Database Setup

**Supabase Project**
1. Create project in Supabase dashboard
2. Run `database-schema.sql` in SQL editor
3. Generate TypeScript types:
   ```bash
   npx supabase gen types typescript --project-id YOUR_PROJECT_ID > src/types/database.types.ts
   ```

**Supabase Client Setup**

`src/lib/supabase/client.ts`:
```typescript
import { createBrowserClient } from '@supabase/ssr'
import { Database } from '@/types/database.types'

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

`src/lib/supabase/server.ts`:
```typescript
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import { Database } from '@/types/database.types'

export function createClient() {
  const cookieStore = cookies()
  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return cookieStore.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          )
        },
      },
    }
  )
}
```

### Day 3-4: Authentication

**Middleware for Auth**

`src/middleware.ts`:
```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({ request })
  
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return request.cookies.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) => {
            request.cookies.set(name, value)
            response.cookies.set(name, value, options)
          })
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()

  // Protect studio routes
  if (request.nextUrl.pathname.startsWith('/studio') && !user) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  // Protect dashboard routes
  if (request.nextUrl.pathname.startsWith('/dashboard') && !user) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  return response
}

export const config = {
  matcher: ['/studio/:path*', '/dashboard/:path*'],
}
```

**Auth Pages**
- `/login` - Email/password sign in
- `/signup` - Choose role (artist/buyer), create account
- `/auth/callback` - Handle OAuth callback

### Day 4-5: Cloudflare R2 Setup

**R2 Configuration**

`src/lib/r2.ts`:
```typescript
import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3'
import { getSignedUrl } from '@aws-sdk/s3-request-presigner'

export const r2Client = new S3Client({
  region: 'auto',
  endpoint: `https://${process.env.R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: process.env.R2_ACCESS_KEY_ID!,
    secretAccessKey: process.env.R2_SECRET_ACCESS_KEY!,
  },
})

export async function getUploadUrl(key: string, contentType: string) {
  const command = new PutObjectCommand({
    Bucket: process.env.R2_BUCKET_NAME,
    Key: key,
    ContentType: contentType,
  })
  return getSignedUrl(r2Client, command, { expiresIn: 3600 })
}

export async function getDownloadUrl(key: string) {
  const command = new GetObjectCommand({
    Bucket: process.env.R2_BUCKET_NAME,
    Key: key,
  })
  return getSignedUrl(r2Client, command, { expiresIn: 3600 })
}
```

**R2 Bucket Setup**
1. Create bucket `lasting-ember` in Cloudflare dashboard
2. Create API token with R2 read/write permissions
3. Set CORS policy for browser uploads

### Day 5-6: Basic Layouts

**Components to Build:**
- `<Navbar />` - Site navigation with auth state
- `<Footer />` - Simple footer
- `<ArtistLayout />` - Studio sidebar navigation
- `<BuyerLayout />` - Dashboard navigation
- `<TrackCard />` - Card component for catalog grid
- `<AudioPlayer />` - Placeholder (built in Week 2)

---

## Week 2: Core Features (Feb 17-23)

### Day 7-8: Track Upload

**Upload Flow**
1. Artist fills form (title, description, genre, mood, etc.)
2. Selects WAV/FLAC file + preview MP3
3. Frontend gets presigned URLs from API
4. Frontend uploads directly to R2
5. Frontend submits metadata to Supabase

**Upload Page** (`/studio/upload`):
- Form with react-hook-form + zod validation
- Drag-and-drop file inputs
- Genre/mood multi-select
- Tags input
- Cover art upload (optional)
- Progress indicator

**API: Get Upload URLs**
```typescript
// POST /api/studio/upload
export async function POST(req: Request) {
  const { filename, contentType, previewFilename } = await req.json()
  
  const trackId = crypto.randomUUID()
  const originalKey = `tracks/${trackId}/original/${filename}`
  const previewKey = `tracks/${trackId}/preview/${previewFilename}`
  
  const [originalUrl, previewUrl] = await Promise.all([
    getUploadUrl(originalKey, contentType),
    getUploadUrl(previewKey, 'audio/mpeg'),
  ])
  
  return Response.json({ trackId, originalUrl, previewUrl, originalKey, previewKey })
}
```

### Day 9-10: Catalog & Search

**Catalog Page** (`/catalog`):
- Track grid with `<TrackCard />` components
- Search bar (text input)
- Filter dropdowns (genre, mood)
- Sort dropdown (newest, popular, price)
- Pagination or infinite scroll

**API: List Tracks**
```typescript
// GET /api/tracks?q=search&genre=rock&mood=energetic&sort=newest
export async function GET(req: Request) {
  const { searchParams } = new URL(req.url)
  const q = searchParams.get('q')
  const genre = searchParams.get('genre')
  const mood = searchParams.get('mood')
  const sort = searchParams.get('sort') || 'newest'
  
  let query = supabase
    .from('tracks')
    .select(`
      *,
      artist:artist_profiles(display_name, slug, avatar_url),
      genres:track_genres(genre:genres(*)),
      moods:track_moods(mood:moods(*))
    `)
    .eq('status', 'approved')
  
  if (q) {
    query = query.textSearch('search_vector', q)
  }
  
  // Apply filters, sorting, pagination...
  
  const { data, error } = await query
  return Response.json({ tracks: data })
}
```

### Day 10-11: Audio Player

**WaveSurfer.js Integration**

`src/components/audio-player.tsx`:
```typescript
'use client'

import { useEffect, useRef, useState } from 'react'
import WaveSurfer from 'wavesurfer.js'
import { Play, Pause, Volume2 } from 'lucide-react'

export function AudioPlayer({ previewUrl }: { previewUrl: string }) {
  const containerRef = useRef<HTMLDivElement>(null)
  const wavesurferRef = useRef<WaveSurfer | null>(null)
  const [isPlaying, setIsPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [duration, setDuration] = useState(0)

  useEffect(() => {
    if (!containerRef.current) return

    const wavesurfer = WaveSurfer.create({
      container: containerRef.current,
      waveColor: '#6b7280',
      progressColor: '#f97316', // Orange brand color
      cursorColor: '#f97316',
      barWidth: 2,
      barRadius: 3,
      height: 60,
    })

    wavesurfer.load(previewUrl)
    wavesurfer.on('ready', () => setDuration(wavesurfer.getDuration()))
    wavesurfer.on('audioprocess', () => setCurrentTime(wavesurfer.getCurrentTime()))
    wavesurfer.on('play', () => setIsPlaying(true))
    wavesurfer.on('pause', () => setIsPlaying(false))

    wavesurferRef.current = wavesurfer

    return () => wavesurfer.destroy()
  }, [previewUrl])

  const togglePlayPause = () => {
    wavesurferRef.current?.playPause()
  }

  return (
    <div className="flex items-center gap-4">
      <button onClick={togglePlayPause} className="...">
        {isPlaying ? <Pause /> : <Play />}
      </button>
      <div ref={containerRef} className="flex-1" />
      <span>{formatTime(currentTime)} / {formatTime(duration)}</span>
    </div>
  )
}
```

### Day 11-12: Track Detail Page

**Track Page** (`/track/[id]`):
- Large cover art
- Track title + artist link
- Audio player with waveform
- Metadata (BPM, key, duration)
- Genres and moods as badges
- License options cards
- "Get License" button for each tier

### Day 12-13: Artist Pages

**Artist Directory** (`/artists`):
- Grid of artist cards
- Simple alphabetical or by track count

**Artist Profile** (`/artist/[slug]`):
- Header with avatar, bio, social links
- Grid of their approved tracks
- Stats (tracks, licenses sold - if public)

### Day 13-14: Stripe Connect

**Connect Onboarding**

`src/lib/stripe.ts`:
```typescript
import Stripe from 'stripe'

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
})

export async function createConnectAccount(artistId: string, email: string) {
  const account = await stripe.accounts.create({
    type: 'express',
    email,
    metadata: { artistId },
  })
  return account.id
}

export async function createConnectOnboardingLink(accountId: string, returnUrl: string) {
  const link = await stripe.accountLinks.create({
    account: accountId,
    refresh_url: `${returnUrl}?refresh=true`,
    return_url: `${returnUrl}?success=true`,
    type: 'account_onboarding',
  })
  return link.url
}
```

**Connect Setup Page** (`/studio/connect`):
1. Check if artist has Stripe account
2. If not, create one via API
3. Redirect to Stripe onboarding
4. Handle return, update `stripe_onboarded = true`

---

## Week 3: Transactions (Feb 24 - Mar 1)

### Day 15-16: Stripe Checkout

**Checkout Session**

```typescript
// POST /api/checkout
export async function POST(req: Request) {
  const { trackId, licenseTypeId, projectName } = await req.json()
  const user = await getUser(req)
  
  // Get track and license type
  const track = await getTrack(trackId)
  const licenseType = await getLicenseType(licenseTypeId)
  const artist = await getArtist(track.artist_id)
  
  // Calculate platform fee (20%)
  const totalAmount = licenseType.default_price_cents
  const platformFee = Math.round(totalAmount * 0.20)
  
  // Create Stripe Checkout Session
  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    customer_email: user.email,
    line_items: [{
      price_data: {
        currency: 'usd',
        product_data: {
          name: `${track.title} - ${licenseType.name} License`,
          description: `By ${artist.display_name}`,
        },
        unit_amount: totalAmount,
      },
      quantity: 1,
    }],
    payment_intent_data: {
      application_fee_amount: platformFee,
      transfer_data: {
        destination: artist.stripe_account_id,
      },
    },
    metadata: {
      trackId,
      licenseTypeId,
      buyerId: user.id,
      projectName,
    },
    success_url: `${process.env.NEXT_PUBLIC_APP_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/track/${trackId}`,
  })
  
  return Response.json({ url: session.url })
}
```

### Day 16-17: Webhook Handling

**Stripe Webhook**

```typescript
// POST /api/webhooks/stripe
export async function POST(req: Request) {
  const body = await req.text()
  const signature = req.headers.get('stripe-signature')!
  
  const event = stripe.webhooks.constructEvent(
    body,
    signature,
    process.env.STRIPE_WEBHOOK_SECRET!
  )
  
  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session
      await handleLicensePurchase(session)
      break
    }
    case 'account.updated': {
      // Stripe Connect account updated
      await handleConnectUpdate(event.data.object)
      break
    }
  }
  
  return new Response('OK')
}

async function handleLicensePurchase(session: Stripe.Checkout.Session) {
  const { trackId, licenseTypeId, buyerId, projectName } = session.metadata!
  
  // Create license record
  await supabase.from('licenses').insert({
    track_id: trackId,
    buyer_id: buyerId,
    license_type_id: licenseTypeId,
    amount_cents: session.amount_total,
    platform_fee_cents: Math.round(session.amount_total * 0.20),
    artist_payout_cents: Math.round(session.amount_total * 0.80),
    stripe_payment_intent_id: session.payment_intent,
    project_name: projectName,
    status: 'active',
    activated_at: new Date().toISOString(),
  })
  
  // Send confirmation emails
  await sendLicenseConfirmationEmail(buyerId, trackId)
  await sendArtistSaleNotification(trackId)
}
```

### Day 17-18: Downloads

**Download Endpoint**

```typescript
// GET /api/download/[licenseId]
export async function GET(
  req: Request,
  { params }: { params: { licenseId: string } }
) {
  const user = await getUser(req)
  
  // Verify license ownership
  const license = await supabase
    .from('licenses')
    .select('*, track:tracks(*)')
    .eq('id', params.licenseId)
    .eq('buyer_id', user.id)
    .eq('status', 'active')
    .single()
  
  if (!license.data) {
    return new Response('License not found', { status: 404 })
  }
  
  // Generate signed download URL
  const downloadUrl = await getDownloadUrl(license.data.track.mp3_file_key)
  
  // Log download
  await supabase.from('license_downloads').insert({
    license_id: params.licenseId,
    ip_address: req.headers.get('x-forwarded-for'),
    user_agent: req.headers.get('user-agent'),
    file_type: 'mp3',
  })
  
  return Response.json({ downloadUrl })
}
```

**Success Page** (`/checkout/success`):
- Thank you message
- License details
- Download button
- Link to My Licenses

### Day 18-19: My Licenses Page

**Licenses Page** (`/dashboard/licenses`):
- Table of purchased licenses
- Track name, artist, license type, date
- Download button for each
- View license terms link

### Day 19-20: Artist Earnings

**Earnings Page** (`/studio/earnings`):
- Total earned (all time)
- Available balance (from Stripe Connect)
- Recent transactions table
- Link to Stripe Express dashboard

**Stripe Balance API**:
```typescript
export async function getArtistBalance(stripeAccountId: string) {
  const balance = await stripe.balance.retrieve({
    stripeAccount: stripeAccountId,
  })
  return balance.available[0]?.amount || 0
}
```

### Day 20-21: Email Notifications

**Resend Setup**

```typescript
import { Resend } from 'resend'

const resend = new Resend(process.env.RESEND_API_KEY)

export async function sendLicenseConfirmationEmail(buyerId: string, trackId: string) {
  const buyer = await getBuyer(buyerId)
  const track = await getTrack(trackId)
  
  await resend.emails.send({
    from: 'Lasting Ember <no-reply@lastingember.com>',
    to: buyer.email,
    subject: `License Confirmed: ${track.title}`,
    html: `
      <h1>Your license is ready!</h1>
      <p>You've successfully licensed "${track.title}".</p>
      <a href="${process.env.NEXT_PUBLIC_APP_URL}/dashboard/licenses">
        Download your track
      </a>
    `,
  })
}
```

**Emails to Implement:**
- Welcome email (on signup)
- License purchased (to buyer)
- Sale notification (to artist)
- Password reset

### Day 21: Final Polish & Testing

**Testing Checklist:**
- [ ] Artist signup → profile → Connect → upload → publish
- [ ] Buyer signup → browse → search → license → download
- [ ] Stripe test mode transactions
- [ ] Webhook handling
- [ ] Email delivery
- [ ] Mobile responsiveness
- [ ] Error handling

**Bug Fixes & Polish:**
- Loading states
- Error messages
- Empty states
- Form validation messages
- Mobile navigation

---

## Deployment

### Vercel Setup

1. Connect GitHub repo to Vercel
2. Configure environment variables
3. Deploy preview branch first
4. Test all flows on preview
5. Deploy to production

### Stripe Live Mode

1. Complete Stripe account verification
2. Get live API keys
3. Update environment variables
4. Create live webhook endpoint
5. Test with real $1 transaction

### Domain & DNS

1. Configure custom domain in Vercel
2. Set up email sending domain (SPF, DKIM for Resend)
3. Update `NEXT_PUBLIC_APP_URL`

### Monitoring

1. Vercel Analytics (included)
2. Sentry for error tracking (free tier)
3. Stripe Dashboard for payment monitoring

---

## Post-Launch (Phase 2 Priorities)

Based on MVP learnings, prioritize:

1. **Subscriptions** - If buyers want recurring access
2. **Better Search** - If catalog grows beyond 500 tracks
3. **Admin Portal** - If moderation becomes time-consuming
4. **Audio Processing** - If manual watermarking is bottleneck
5. **PDF Licenses** - If buyers request formal contracts

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Stripe Connect delays | Start onboarding early, have backup plan (manual payouts) |
| Audio file issues | Test with various file formats early |
| Search performance | Keep initial catalog small, monitor queries |
| Auth edge cases | Use Supabase examples, test thoroughly |
| R2 upload failures | Implement retry logic, clear error messages |

---

## Daily Standup Questions

Each day, answer:
1. What did I complete yesterday?
2. What am I working on today?
3. What's blocking me?

Track progress in a simple Notion or GitHub project board.
