-- ─── TABLE: Center_CompaniesLicence ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_CompaniesLicence" (
    CompaniesLicenceNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    LicenceKey character varying(50) NOT NULL,
    Name character varying(50) NOT NULL,
    Version character varying(50) NOT NULL,
    DB character varying(50) NOT NULL,
    UserCnt integer NOT NULL,
    CompaniesLicenceDate timestamp without time zone NOT NULL,
    Enabled boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
