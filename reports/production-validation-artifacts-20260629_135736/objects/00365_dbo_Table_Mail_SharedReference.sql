-- ─── TABLE: Mail_SharedReference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_SharedReference" (
    ReferenceNo serial NOT NULL,
    MailNo bigint NOT NULL,
    UserNo integer NOT NULL,
    ReadDate timestamp without time zone NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
