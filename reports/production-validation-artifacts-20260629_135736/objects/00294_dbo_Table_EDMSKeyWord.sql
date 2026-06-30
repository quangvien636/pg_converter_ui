-- ─── TABLE: EDMSKeyWord ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSKeyWord" (
    id serial NOT NULL,
    Docid integer,
    KeyWord character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
