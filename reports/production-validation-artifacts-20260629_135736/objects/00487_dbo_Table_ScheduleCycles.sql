-- ─── TABLE: ScheduleCycles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCycles" (
    CycleNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    NameEn character varying(100),
    NameJp character varying(100),
    NameCh character varying(100),
    NameVn character varying(100),
    SortOrder integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
