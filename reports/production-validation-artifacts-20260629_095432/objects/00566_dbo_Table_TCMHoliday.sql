-- ─── TABLE: TCMHoliday ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMHoliday" (
    HolidayNo serial NOT NULL,
    HolidayDate date,
    HolidayName character varying(50),
    IsRepeat boolean,
    IsLunar boolean,
    IsHoliday boolean,
    DayType character(1),
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
