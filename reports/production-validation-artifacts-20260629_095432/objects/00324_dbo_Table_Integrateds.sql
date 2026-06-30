-- ─── TABLE: Integrateds ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrateds" (
    IntegratedNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Title character varying(300) NOT NULL,
    DivisionNo integer NOT NULL,
    Content text NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    Important boolean NOT NULL,
    IsShare boolean NOT NULL,
    IsAttach boolean NOT NULL,
    TotalViews integer NOT NULL,
    CurrentViews integer NOT NULL,
    IsContentImg boolean NOT NULL,
    TreeRoot integer,
    TreeNo integer,
    TreeItem2 integer,
    TreeItem3 integer,
    TypeNo integer,
    IsDelete character(1),
    IsImportant boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
