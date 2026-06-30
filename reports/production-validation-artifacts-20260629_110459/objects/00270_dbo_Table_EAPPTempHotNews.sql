-- ─── TABLE: EAPPTempHotNews ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPTempHotNews" (
    ID serial NOT NULL,
    EAPPDocID integer,
    HnewDocID integer,
    Title character varying(1000),
    Content text,
    WriterID character varying(100),
    WriterNm character varying(100),
    MgmCd character varying(8000),
    MgmNm text,
    Sdate character varying(16),
    Edate character varying(16),
    Import character varying(1),
    PopYn character varying(1),
    GroupCd character varying(4),
    AuthCd character varying(20),
    OrgGubun character varying(30)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
