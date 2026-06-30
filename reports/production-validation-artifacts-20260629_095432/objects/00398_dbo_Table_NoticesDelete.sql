-- ─── TABLE: NoticesDelete ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticesDelete" (
    NoticeNo integer NOT NULL,
    Title character varying(300),
    UserNo integer,
    DeleteDate timestamp without time zone,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone,
    DivisionNo integer,
    Content text,
    StartDate timestamp without time zone,
    EndDate timestamp without time zone,
    Important boolean,
    IsShare boolean,
    IsAttach boolean,
    TotalViews integer,
    CurrentViews integer,
    IsContentImg boolean,
    IsPopup boolean,
    DepartNo integer,
    PPStartDate timestamp without time zone,
    PPEndDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
