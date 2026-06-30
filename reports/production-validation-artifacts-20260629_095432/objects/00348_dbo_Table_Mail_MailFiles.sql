-- ─── TABLE: Mail_MailFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailFiles" (
    FileNo bigserial NOT NULL,
    MailNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Size integer NOT NULL,
    PRIMARY KEY (FileNo, MailNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
