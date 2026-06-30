-- ─── TABLE: NoticeSyn_Divisions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_Divisions" (
    DivisionNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Sort integer,
    Status integer,
    viewmode integer,
    ID serial NOT NULL,
    Name_EN character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
