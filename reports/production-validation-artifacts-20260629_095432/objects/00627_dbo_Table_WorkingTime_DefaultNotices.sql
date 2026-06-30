-- ─── TABLE: WorkingTime_DefaultNotices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_DefaultNotices" (
    NoticeNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    TimeType integer NOT NULL,
    Content character varying(500) NOT NULL,
    Content_Ko character varying(500),
    Content_Vn character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
