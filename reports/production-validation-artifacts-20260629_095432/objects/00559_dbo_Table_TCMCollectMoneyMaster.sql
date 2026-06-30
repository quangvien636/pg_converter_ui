-- ─── TABLE: TCMCollectMoneyMaster ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMCollectMoneyMaster" (
    Seq serial NOT NULL,
    Title character varying(1000),
    CustomerID integer,
    Customer character varying(1000),
    Content text,
    SellingDate character varying(10),
    SellingMoney bigint,
    AdrateMoney bigint,
    CollectDate character varying(10),
    CollectMoney bigint,
    Divide integer,
    IsComplete smallint,
    TotalMoney bigint,
    RestMoney bigint,
    RegUserNo integer,
    RegUserName character varying(100),
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModUserName character varying(100),
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
