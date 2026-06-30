-- ─── TABLE: EDMSAuthUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSAuthUser" (
    ID serial NOT NULL,
    DOCID integer NOT NULL,
    UserID character varying(50) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
