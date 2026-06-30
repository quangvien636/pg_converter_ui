-- ─── TABLE: EDMSKeywordMaster ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSKeywordMaster" (
    ID serial NOT NULL,
    ItemNm1 character varying(100),
    ItemNm2 character varying(100),
    ItemNm3 character varying(100),
    ItemNm4 character varying(100),
    SortOrd character varying(10),
    RegDate timestamp without time zone,
    RegId character varying(50),
    ModDate timestamp without time zone,
    ModId character varying(50),
    ItemNm5 character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
