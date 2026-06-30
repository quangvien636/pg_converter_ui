-- ─── TABLE: Center_IPFilters ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_IPFilters" (
    FilterNo serial NOT NULL,
    ClientIP character varying(50) NOT NULL,
    Allow boolean NOT NULL,
    SortNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
