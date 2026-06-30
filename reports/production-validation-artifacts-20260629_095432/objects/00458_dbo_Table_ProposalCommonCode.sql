-- ─── TABLE: ProposalCommonCode ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ProposalCommonCode" (
    CommonCode serial NOT NULL,
    ClassCode integer,
    CommonName character varying(100),
    CommonNameEN character varying(100),
    CommonNameVN character varying(100),
    CommonNameCH character varying(100),
    CommonNameJP character varying(100),
    SortOrder integer,
    UseYn character(1),
    RegDate timestamp without time zone,
    RegUserNo integer,
    ModDate timestamp without time zone,
    ModUserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
