-- ─── TABLE: _TCOMCalendarHoliday ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."_TCOMCalendarHoliday" (
    CompanySeq integer NOT NULL,
    Solar integer NOT NULL,
    SMHolidayType integer NOT NULL,
    HolidayName character varying(50) NOT NULL,
    CountrySeq integer NOT NULL,
    IsCommon integer NOT NULL,
    Remark character varying(50) NOT NULL,
    LastUserSeq integer NOT NULL,
    LastDateTime timestamp without time zone NOT NULL,
    PRIMARY KEY (CompanySeq, Solar)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
