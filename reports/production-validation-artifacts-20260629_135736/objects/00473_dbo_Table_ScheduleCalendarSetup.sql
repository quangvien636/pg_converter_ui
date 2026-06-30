-- ─── TABLE: ScheduleCalendarSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarSetup" (
    UserNo integer NOT NULL PRIMARY KEY,
    CalendarViewType integer NOT NULL DEFAULT 0,
    StartWeek integer NOT NULL DEFAULT 0,
    DefaultCalendarNo integer NOT NULL DEFAULT 0,
    DivisionUseYN character varying(1) NOT NULL DEFAULT 'Y',
    RegUserNo integer NOT NULL DEFAULT 0,
    RegDate timestamp without time zone NOT NULL DEFAULT '1900-01-01',
    ModUserNo integer NOT NULL DEFAULT 0,
    ModDate timestamp without time zone NOT NULL DEFAULT '1900-01-01',
    IsFunctionComplete boolean,
    is12hours boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
