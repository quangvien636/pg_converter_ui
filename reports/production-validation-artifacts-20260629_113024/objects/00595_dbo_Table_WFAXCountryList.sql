-- ─── TABLE: WFAXCountryList ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXCountryList" (
    No serial NOT NULL,
    CountryNum character varying(5),
    CountryName character varying(100),
    SortOrder integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
