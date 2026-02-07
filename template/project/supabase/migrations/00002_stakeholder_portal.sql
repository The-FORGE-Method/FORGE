-- FORGE Stakeholder Portal Schema
-- First-party visibility and feedback per FORGE method Stakeholder Interface extension
--
-- This migration adds portal infrastructure. Customize as needed.

-- =============================================================================
-- FEEDBACK SUBMISSIONS
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  -- Submission content
  type TEXT NOT NULL CHECK (type IN ('bug', 'feature', 'question', 'feedback')),
  title TEXT NOT NULL,
  body TEXT,

  -- Lifecycle
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'triaged', 'planned', 'resolved', 'wont_fix')),

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.submissions IS 'Stakeholder feedback submissions';
COMMENT ON COLUMN public.submissions.type IS 'bug, feature, question, or feedback';
COMMENT ON COLUMN public.submissions.status IS 'Lifecycle: open -> triaged -> planned -> resolved/wont_fix';

-- =============================================================================
-- SUBMISSION VOTES (upvote only)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.submission_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id UUID NOT NULL REFERENCES public.submissions(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(submission_id, user_id)
);

COMMENT ON TABLE public.submission_votes IS 'Upvotes on submissions (one per user per submission)';

-- =============================================================================
-- AI CONVERSATIONS
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.ai_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  -- Conversation metadata
  title TEXT,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.ai_conversations IS 'Stakeholder AI conversation sessions';

-- =============================================================================
-- AI MESSAGES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.ai_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES public.ai_conversations(id) ON DELETE CASCADE,

  -- Message content
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
  content TEXT NOT NULL,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.ai_messages IS 'Messages within AI conversations';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_submissions_org_id ON public.submissions(organization_id);
CREATE INDEX IF NOT EXISTS idx_submissions_author_id ON public.submissions(author_id);
CREATE INDEX IF NOT EXISTS idx_submissions_status ON public.submissions(status);
CREATE INDEX IF NOT EXISTS idx_submission_votes_submission ON public.submission_votes(submission_id);
CREATE INDEX IF NOT EXISTS idx_ai_conversations_org_id ON public.ai_conversations(organization_id);
CREATE INDEX IF NOT EXISTS idx_ai_conversations_user_id ON public.ai_conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_messages_conversation ON public.ai_messages(conversation_id);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submission_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_messages ENABLE ROW LEVEL SECURITY;

-- Submissions: all org members can view
CREATE POLICY "submissions_select" ON public.submissions
  FOR SELECT USING (organization_id = public.current_org_id());

-- Submissions: stakeholders can create
CREATE POLICY "submissions_insert" ON public.submissions
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND author_id = auth.uid()
  );

-- Submissions: only admins/owners can update status
CREATE POLICY "submissions_update" ON public.submissions
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.has_any_role(ARRAY['owner', 'admin', 'member'])
  );

-- Votes: all org members can view
CREATE POLICY "votes_select" ON public.submission_votes
  FOR SELECT USING (
    submission_id IN (
      SELECT id FROM public.submissions
      WHERE organization_id = public.current_org_id()
    )
  );

-- Votes: any org member can vote
CREATE POLICY "votes_insert" ON public.submission_votes
  FOR INSERT WITH CHECK (
    user_id = auth.uid()
    AND submission_id IN (
      SELECT id FROM public.submissions
      WHERE organization_id = public.current_org_id()
    )
  );

-- Votes: can remove own vote
CREATE POLICY "votes_delete" ON public.submission_votes
  FOR DELETE USING (user_id = auth.uid());

-- AI Conversations: users can view own conversations
CREATE POLICY "conversations_select" ON public.ai_conversations
  FOR SELECT USING (
    user_id = auth.uid()
    AND organization_id = public.current_org_id()
  );

-- AI Conversations: users can create own conversations
CREATE POLICY "conversations_insert" ON public.ai_conversations
  FOR INSERT WITH CHECK (
    user_id = auth.uid()
    AND organization_id = public.current_org_id()
  );

-- AI Messages: users can view messages in their conversations
CREATE POLICY "messages_select" ON public.ai_messages
  FOR SELECT USING (
    conversation_id IN (
      SELECT id FROM public.ai_conversations
      WHERE user_id = auth.uid()
    )
  );

-- AI Messages: users can add messages to their conversations
CREATE POLICY "messages_insert" ON public.ai_messages
  FOR INSERT WITH CHECK (
    conversation_id IN (
      SELECT id FROM public.ai_conversations
      WHERE user_id = auth.uid()
    )
  );

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================

CREATE TRIGGER submissions_updated_at
  BEFORE UPDATE ON public.submissions
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER ai_conversations_updated_at
  BEFORE UPDATE ON public.ai_conversations
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
