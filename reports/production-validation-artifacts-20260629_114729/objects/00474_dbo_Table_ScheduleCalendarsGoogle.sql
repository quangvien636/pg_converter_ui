-- ─── TABLE: ScheduleCalendarsGoogle ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarsGoogle" (
    UserNo integer NOT NULL,
    CalendarNo integer NOT NULL,
    GoogleCalendarID character varying(500) NOT NULL,
    GoogleCalendarUri character varying(500) NOT NULL,
    PRIMARY KEY (UserNo, CalendarNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
