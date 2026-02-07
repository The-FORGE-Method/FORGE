# 00_inbox

**Feature Request Queue — Submit folders, not files.**

---

## How to Submit a Feature Request

### Step 1: Create a Folder

```
00_inbox/
└── <your-feature-slug>/
    ├── README.md           <- Required: Brief description of the request
    ├── threads/            <- Transcripts, chat exports, meeting notes
    │   └── *.md
    └── assets/             <- Images, sketches, PDFs, videos
        └── *.png, *.pdf, etc.
```

### Step 2: Name Your Folder

Use a short descriptive slug:
- `auth-extension`
- `dashboard-redesign`
- `notification-system`

**Do NOT** include dates — the pipeline adds timestamps automatically.

### Step 3: Include a README.md

Every submission folder **must** have a `README.md` with:

```markdown
# Feature Request: <Title>

## Summary
[2-3 sentences describing what you want]

## Problem
[What problem does this solve?]

## Proposed Approach (Optional)
[If you have ideas on how to solve it]

## Materials Included
- threads/brainstorm-notes.md
- assets/wireframe-sketch.png

## Submitter
[Your name/role or agent name]
```

### Step 4: Start Processing

```
/forge-rd start <your-folder-slug>
```

---

## Rules

- **Folders only** — No loose files in the inbox root
- **One feature per folder** — Split multi-feature requests
- **README.md required** — Every folder needs one
- See `_example-submission/` for a complete example

---

*Submit features as folders. The pipeline handles the rest.*
