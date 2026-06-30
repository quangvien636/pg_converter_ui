-- ─── TABLE: DMake_Replies ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Replies" (
    ReplyNo bigserial NOT NULL,
    ContentNo bigint,
    Content text DEFAULT '',
    GroupNo integer DEFAULT 0,
    ParentNo bigint DEFAULT 0,
    Depth integer DEFAULT 1,
    OrderNo integer DEFAULT 1,
    RegUserNo integer DEFAULT 0,
    RegUserName character varying(100) DEFAULT '',
    RegDate timestamp without time zone DEFAULT now(),
    ModUserNo integer DEFAULT 0,
    ModUserName character varying(100) DEFAULT '',
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
