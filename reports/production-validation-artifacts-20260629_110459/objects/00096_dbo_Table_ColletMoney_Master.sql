-- ─── TABLE: ColletMoney_Master ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ColletMoney_Master" (
    Seq integer NOT NULL,
    Title character varying(1024) NOT NULL,
    Customer character varying(1024),
    Content text NOT NULL,
    userpkno integer NOT NULL,
    RegDate character(10) NOT NULL,
    SellingDate character(10) NOT NULL,
    SellingMoney bigint,
    AdrateMoney bigint NOT NULL,
    ColletDate character(10) NOT NULL,
    ColletMoney bigint NOT NULL,
    Divide integer,
    homepagepkno integer,
    IsComplete smallint,
    TotalMoney bigint,
    RestMoney bigint,
    Name character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
