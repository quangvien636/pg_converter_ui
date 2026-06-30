-- ─── TABLE: ScheduleCalendarPermisions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarPermisions" (
    CalendarNo integer NOT NULL,
    UserNo integer,
    DepartNo integer,
    PositionNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
