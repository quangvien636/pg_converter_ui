-- ─── TABLE: NoticeComments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeComments" (
    CommentNo serial NOT NULL,
    NoticeNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Content character varying(500) NOT NULL,
    ModUserName character varying(100),
    ModPositionNo integer,
    ModPositionName character varying(100),
    ModDepartNo integer,
    ModDepartName character varying(100),
    GroupNo bigint,
    OrderNo integer,
    Depth integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
