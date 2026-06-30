-- ─── TABLE: ScheduleDdaySharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaySharers" (
    DdayNo integer NOT NULL DEFAULT 0,
    UserNo integer NOT NULL DEFAULT 0,
    DepartNo integer NOT NULL DEFAULT 0,
    PositionNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
