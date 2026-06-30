-- ─── TABLE: EDMSKeywordSub ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSKeywordSub" (
    ID serial NOT NULL,
    ItemNm1 character varying(100),
    ItemNm2 character varying(100),
    ItemNm3 character varying(100),
    ItemNm4 character varying(100),
    MasterID integer NOT NULL,
    ItemNm5 character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
