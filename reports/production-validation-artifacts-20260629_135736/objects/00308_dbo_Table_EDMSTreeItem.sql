-- ─── TABLE: EDMSTreeItem ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSTreeItem" (
    DivID character varying(20) NOT NULL,
    UserID character varying(50),
    ItemNm1 character varying(50),
    ItemNm2 character varying(50),
    ItemNm3 character varying(50),
    ItemNm4 character varying(50),
    ParentID character varying(100),
    SortOrd integer,
    UseYn character(1),
    RegID character varying(50),
    RegDate timestamp without time zone,
    ModID character varying(50),
    ModDate timestamp without time zone,
    ID character varying(100) NOT NULL DEFAULT '-1',
    StorePeriod character varying(10),
    PRIMARY KEY (DivID, ID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
