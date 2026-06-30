-- ─── TABLE: ScheduleCalendarDefaultSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarDefaultSharers" (
    CalendarNo integer,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    PositionNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
