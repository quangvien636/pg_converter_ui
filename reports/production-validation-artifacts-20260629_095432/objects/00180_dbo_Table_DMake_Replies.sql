-- ─── TABLE: DMake_Replies ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Replies" (
    ReplyNo bigserial NOT NULL,
    ContentNo bigint,
    Content text,
    GroupNo integer,
    ParentNo bigint,
    Depth integer,
    OrderNo integer,
    RegUserNo integer,
    RegUserName character varying(100),
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModUserName character varying(100),
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
