-- ─── TABLE: Center_Applications ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_Applications" (
    ApplicationNo serial NOT NULL,
    ProjectCode character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    Status integer NOT NULL,
    Option text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
