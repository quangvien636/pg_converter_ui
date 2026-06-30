-- ─── TABLE: Mail_MailThreads ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailThreads" (
    MailNo bigserial NOT NULL,
    ConversationNo bigint NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
