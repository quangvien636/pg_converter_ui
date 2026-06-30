-- ─── TABLE: WorkingTime_DisplayPaths ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_DisplayPaths" (
    PathNo bigserial NOT NULL,
    StartWorkingNo integer NOT NULL,
    EndWorkingNo integer NOT NULL,
    Paths text NOT NULL,
    Distance integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
