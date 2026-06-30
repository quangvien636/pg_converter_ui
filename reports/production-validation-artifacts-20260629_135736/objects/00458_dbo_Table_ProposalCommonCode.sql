-- ─── TABLE: ProposalCommonCode ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ProposalCommonCode" (
    CommonCode serial NOT NULL,
    ClassCode integer,
    CommonName character varying(100),
    CommonNameEN character varying(100),
    CommonNameVN character varying(100),
    CommonNameCH character varying(100),
    CommonNameJP character varying(100),
    SortOrder integer DEFAULT 1,
    UseYn character(1) DEFAULT 'Y',
    RegDate timestamp without time zone DEFAULT now(),
    RegUserNo integer,
    ModDate timestamp without time zone DEFAULT now(),
    ModUserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
