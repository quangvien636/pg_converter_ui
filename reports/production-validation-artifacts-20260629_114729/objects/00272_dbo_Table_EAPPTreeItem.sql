-- ─── TABLE: EAPPTreeItem ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPTreeItem" (
    ID serial NOT NULL,
    DivID character varying(20),
    UserID character varying(50),
    ItemNm1 character varying(50),
    ItemNm2 character varying(50),
    ItemNm3 character varying(50),
    ItemNm4 character varying(50),
    ParentID integer,
    SortOrd integer,
    UseYn character(1),
    RegID character varying(50),
    RegDate timestamp without time zone,
    ModID character varying(50),
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
