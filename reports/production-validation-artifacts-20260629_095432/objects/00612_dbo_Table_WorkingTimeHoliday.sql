-- ─── TABLE: WorkingTimeHoliday ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTimeHoliday" (
    HolidayNo serial NOT NULL,
    HolidayDate date NOT NULL,
    HolidayName character varying(100) NOT NULL,
    IsRepeat boolean NOT NULL,
    IsLunar boolean NOT NULL,
    IsHoliday boolean NOT NULL,
    DayType character(1) NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
