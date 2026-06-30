-- ─── TABLE: Mail_MailCalendars ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailCalendars" (
    MailNo bigint NOT NULL PRIMARY KEY,
    Content text NOT NULL,
    IsConvertXml boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
