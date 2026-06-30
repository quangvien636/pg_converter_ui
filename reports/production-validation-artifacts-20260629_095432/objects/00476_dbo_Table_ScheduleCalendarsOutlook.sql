-- ─── TABLE: ScheduleCalendarsOutlook ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarsOutlook" (
    UserNo integer NOT NULL,
    CalendarNo integer NOT NULL,
    OutlookEntryID character varying(500) NOT NULL,
    PRIMARY KEY (UserNo, CalendarNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
