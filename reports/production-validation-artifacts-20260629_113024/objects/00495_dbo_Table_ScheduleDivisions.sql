-- ─── TABLE: ScheduleDivisions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDivisions" (
    DivisionNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    NameEn character varying(100),
    NameJp character varying(100),
    NameCh character varying(100),
    NameVn character varying(100),
    Color character(6) NOT NULL,
    SortOrder integer NOT NULL,
    NoOldverson character varying(10),
    writer character varying(20)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
