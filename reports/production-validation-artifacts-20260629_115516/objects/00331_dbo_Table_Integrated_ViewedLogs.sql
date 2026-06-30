-- ─── TABLE: Integrated_ViewedLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrated_ViewedLogs" (
    LogNo bigserial NOT NULL,
    TreeNo integer NOT NULL,
    ContentNo bigint NOT NULL,
    UserNo integer NOT NULL,
    UserName character varying(100) NOT NULL,
    PositionNo integer NOT NULL,
    PositionName character varying(100) NOT NULL,
    DepartNo integer NOT NULL,
    DepartName character varying(100) NOT NULL,
    ViewedDate timestamp without time zone NOT NULL,
    ClientIP character varying(100) NOT NULL,
    PRIMARY KEY (LogNo, TreeNo, ContentNo, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
