-- ─── TABLE: Mail_MailSigns ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailSigns" (
    SignNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    AccNo bigint NOT NULL,
    Name character varying(100) NOT NULL,
    Content text NOT NULL,
    Enabled boolean NOT NULL,
    PRIMARY KEY (SignNo, AccNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
