-- ─── TABLE: ScheduleContentSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentSharers" (
    ScheduleNo integer NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    PositionNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
