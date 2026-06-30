-- ─── TABLE: Mail_Servers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_Servers" (
    ServerNo serial NOT NULL,
    ServerHost character varying(100) NOT NULL,
    MailDomain character varying(100) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
