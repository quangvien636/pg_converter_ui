-- ─── TABLE: NSFACompanyBns ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFACompanyBns" (
    Seq serial NOT NULL,
    CmSeq integer NOT NULL,
    CmFName character varying(100),
    CmFID character varying(100),
    CmSName character varying(500),
    CmSID character varying(500),
    CmSalsDate character varying(100),
    CmSales character varying(100),
    CmType1 character varying(100),
    CmPath character varying(100),
    CmNDate character varying(100),
    CmType2 character varying(100),
    CmCont text,
    CmRanking character varying(50),
    PRIMARY KEY (Seq, CmSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
