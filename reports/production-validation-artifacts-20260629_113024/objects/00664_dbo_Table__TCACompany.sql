-- ─── TABLE: _TCACompany ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."_TCACompany" (
    CompanySeq integer NOT NULL PRIMARY KEY,
    CompanyName character varying(100),
    CompanyShortName character varying(100),
    OrderSeq integer NOT NULL,
    Owner character varying(30),
    OwnerJpName character varying(100),
    CompanyNo character varying(30),
    SetUpDate character(8),
    OwnerID character varying(200),
    CellPhone character varying(30),
    AuthStockQty integer,
    IssueStockQty integer,
    StockAmt numeric(19,5),
    SttlMonth integer,
    CustSeq integer,
    DSNSeq integer,
    LastUserSeq integer,
    LastDateTime timestamp without time zone,
    BMSeq integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
