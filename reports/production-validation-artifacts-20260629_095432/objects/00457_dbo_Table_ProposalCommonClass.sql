-- ─── TABLE: ProposalCommonClass ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ProposalCommonClass" (
    ClassCode serial NOT NULL,
    ClassName character varying(100),
    ClassNameEN character varying(100),
    ClassNameVN character varying(100),
    ClassNameCH character varying(100),
    ClassNameJP character varying(100),
    ClassDesc character varying(1000),
    UseYn character(1),
    RegDate timestamp without time zone,
    RegUserNo integer,
    ModDate timestamp without time zone,
    ModUserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
