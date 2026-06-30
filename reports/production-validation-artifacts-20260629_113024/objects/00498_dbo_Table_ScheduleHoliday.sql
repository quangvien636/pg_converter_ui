-- ─── TABLE: ScheduleHoliday ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleHoliday" (
    HolidayNo serial NOT NULL,
    HolidayDate date NOT NULL,
    HolidayName character varying(100) NOT NULL,
    IsRepeat boolean NOT NULL DEFAULT false,
    IsLunar boolean NOT NULL DEFAULT false,
    IsHoliday boolean NOT NULL DEFAULT true,
    DayType character(1) NOT NULL DEFAULT 'H',
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    color character(6)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
