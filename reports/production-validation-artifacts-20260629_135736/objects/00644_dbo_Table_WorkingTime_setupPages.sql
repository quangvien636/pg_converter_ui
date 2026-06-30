-- ─── TABLE: WorkingTime_setupPages ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_setupPages" (
    Id serial NOT NULL,
    IsPage integer,
    hidetime integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
