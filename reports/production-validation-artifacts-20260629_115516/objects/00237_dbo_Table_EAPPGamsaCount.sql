-- ─── TABLE: EAPPGamsaCount ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPGamsaCount" (
    ID serial NOT NULL,
    GamsaYear character varying(10),
    GamsaCount integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
