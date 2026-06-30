-- ─── TABLE: EAPPDepartAuth ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDepartAuth" (
    ID serial NOT NULL,
    UserID character varying(50) NOT NULL,
    DepartID character varying(10),
    IsLow character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
