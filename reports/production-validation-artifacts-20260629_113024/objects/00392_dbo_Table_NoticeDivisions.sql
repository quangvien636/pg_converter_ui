-- ─── TABLE: NoticeDivisions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeDivisions" (
    DivisionNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(500) NOT NULL,
    Sort integer,
    Status integer,
    ViewMode integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
