-- ─── TABLE: NoticeSyn_ViewedLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_ViewedLogs" (
    LogNo bigserial NOT NULL,
    DividionNo integer NOT NULL,
    NoticeNo bigint NOT NULL,
    UserNo integer NOT NULL,
    UserName character varying(100) NOT NULL,
    PositionNo integer NOT NULL,
    PositionName character varying(100) NOT NULL,
    DepartNo integer NOT NULL,
    DepartName character varying(100) NOT NULL,
    ViewedDate timestamp without time zone NOT NULL,
    ClientIP character varying(100) NOT NULL,
    PRIMARY KEY (LogNo, DividionNo, NoticeNo, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
