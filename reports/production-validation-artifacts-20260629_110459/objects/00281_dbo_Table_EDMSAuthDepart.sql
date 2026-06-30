-- ─── TABLE: EDMSAuthDepart ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSAuthDepart" (
    ID serial NOT NULL,
    DOCID integer NOT NULL,
    ORGCD integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
