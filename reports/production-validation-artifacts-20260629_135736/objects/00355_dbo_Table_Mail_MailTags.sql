-- ─── TABLE: Mail_MailTags ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailTags" (
    TagNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    ImageNo integer NOT NULL,
    Name character varying(200) NOT NULL,
    TotalCount integer NOT NULL,
    UnReadCount integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
