-- ─── TABLE: Mail_MailLargeFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailLargeFiles" (
    FileNo bigserial NOT NULL,
    MailNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Size integer NOT NULL,
    ExpirationDate date NOT NULL,
    PRIMARY KEY (FileNo, MailNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
