-- ─── TABLE: CompanyLicenseInformation ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CompanyLicenseInformation" (
    CompanyLicenseInformationNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    LicenceKey character varying(50) NOT NULL,
    Name character varying(50) NOT NULL,
    Version character varying(50) NOT NULL,
    DB character varying(50) NOT NULL,
    UserCnt integer NOT NULL,
    CompanyLicenseInformationDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
