-- ─── TABLE: Mail_MailConversations ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailConversations" (
    ConversationNo bigserial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    MailCount integer NOT NULL,
    Title character varying(500) NOT NULL,
    Address text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
