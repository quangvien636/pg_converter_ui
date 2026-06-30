-- ─── TABLE: WorkingTime_Notices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Notices" (
    NoticeNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    TimeType integer NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    Content character varying(500) NOT NULL,
    Content_Ko character varying(500),
    Content_Vn character varying(500),
    LocationNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
