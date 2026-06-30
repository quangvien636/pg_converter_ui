-- ─── TABLE: TCMContractInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMContractInfo" (
    ContractNo serial NOT NULL,
    Title character varying(100),
    Contents text,
    Checkday character(1),
    EndDate character varying(8),
    EndTime character varying(6),
    State character(1),
    RegUserNo integer,
    RegUserName character varying(100),
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModUserName character varying(100),
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
