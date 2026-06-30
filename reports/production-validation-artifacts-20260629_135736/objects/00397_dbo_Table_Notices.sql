-- ─── TABLE: Notices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Notices" (
    NoticeNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    Title character varying(300) NOT NULL,
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
    IsPopup boolean NOT NULL DEFAULT false,
    DepartNo integer,
    PPStartDate date,
    PPEndDate date,
    isdeleted integer NOT NULL DEFAULT 0,
    IsSeen2 integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
