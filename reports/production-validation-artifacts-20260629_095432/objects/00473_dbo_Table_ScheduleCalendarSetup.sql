-- ─── TABLE: ScheduleCalendarSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarSetup" (
    UserNo integer NOT NULL PRIMARY KEY,
    CalendarViewType integer NOT NULL,
    StartWeek integer NOT NULL,
    DefaultCalendarNo integer NOT NULL,
    DivisionUseYN character varying(1) NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    IsFunctionComplete boolean,
    is12hours boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
