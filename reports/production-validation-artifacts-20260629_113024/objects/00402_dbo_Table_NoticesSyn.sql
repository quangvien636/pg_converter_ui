-- ─── TABLE: NoticesSyn ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticesSyn" (
    NoticeNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    Title character varying(500) NOT NULL,
    DivisionNo integer NOT NULL,
    Content text NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    Important boolean NOT NULL,
    IsShare boolean NOT NULL,
    IsAttach boolean NOT NULL,
    TotalViews integer NOT NULL DEFAULT 0,
    CurrentViews integer NOT NULL,
    IsContentImg boolean NOT NULL,
    TypeNo integer,
    IsDelete character(1),
    IntegratedNo integer,
    TreeRoot integer NOT NULL DEFAULT 0,
    TreeNo integer NOT NULL DEFAULT 0,
    TreeItem2 integer NOT NULL DEFAULT 0,
    TreeItem3 integer NOT NULL DEFAULT 0,
    Options integer NOT NULL DEFAULT 0,
    IsImportant boolean NOT NULL DEFAULT 'False'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
