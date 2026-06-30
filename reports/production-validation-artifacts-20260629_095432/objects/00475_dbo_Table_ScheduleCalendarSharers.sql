-- ─── TABLE: ScheduleCalendarSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarSharers" (
    CalendarNo integer NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    PositionNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
