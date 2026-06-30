-- ─── TABLE: ScheduleCalendars ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendars" (
    CalendarNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Type integer NOT NULL,
    Color character(6) NOT NULL,
    UseLevel integer NOT NULL,
    Description character varying(500) NOT NULL,
    IsNotiNote boolean NOT NULL,
    IsNotiMail boolean NOT NULL,
    IsNotiSMS boolean NOT NULL,
    IsNotiPopup boolean NOT NULL,
    NotiTimeType integer NOT NULL,
    IsFixed boolean NOT NULL,
    SortOrder double precision NOT NULL,
    IsActive boolean,
    isall boolean,
    isDetail boolean,
    Detail text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
