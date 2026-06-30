-- ─── TABLE: EAPPFormDepart ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPFormDepart" (
    ID serial NOT NULL,
    FormID integer,
    DepartID character varying(4)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
