-- ─── TABLE: ScheduleViewCalendars ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleViewCalendars" (
    UserNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    IsToDoView boolean NOT NULL,
    IsDdayView boolean NOT NULL,
    ViewCalendars character varying(300) NOT NULL,
    IsCompanyView boolean,
    IsPersonalView boolean,
    IsShareView boolean,
    IsAllView boolean,
    IsWorkToDoView boolean,
    IsSubCompanyOpen boolean,
    IsSubPersonalOpen boolean,
    IsSubShareOpen boolean,
    IsSubWorkToDoOpen boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
