-- ─── TABLE: Mail_MailAdminSigns ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailAdminSigns" (
    AmdinSignNo bigserial NOT NULL,
    Content text NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
