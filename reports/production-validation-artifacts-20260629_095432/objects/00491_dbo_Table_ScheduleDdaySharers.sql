-- ─── TABLE: ScheduleDdaySharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaySharers" (
    DdayNo integer NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    PositionNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
