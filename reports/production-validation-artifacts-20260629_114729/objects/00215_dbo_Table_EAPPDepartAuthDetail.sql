-- ─── TABLE: EAPPDepartAuthDetail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDepartAuthDetail" (
    ID serial NOT NULL,
    DAID integer NOT NULL,
    Forms character varying(100) NOT NULL,
    IsModify character(1) NOT NULL,
    IsCancel character(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
