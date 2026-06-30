-- ─── TABLE: NSFACompanyInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFACompanyInfo" (
    Seq serial NOT NULL,
    Writer character varying(50),
    RegDate character varying(50),
    CmName character varying(50),
    CmNum character varying(50),
    CmType1 character varying(50),
    CmType2 character varying(50),
    CmDate character varying(50),
    CmCEO character varying(50),
    CmSite character varying(50),
    CmType3 character varying(50),
    CmTel character varying(50),
    CmFax character varying(50),
    CmAdrr character varying(100),
    CmBank character varying(50),
    CmTrust character varying(50),
    CmSales character varying(50),
    CmType4 character varying(50),
    CmScale character varying(50),
    CmStaff character varying(1000),
    CmEtc text,
    CmRegion character varying(50),
    CmRanking character varying(50),
    CompanyType character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
