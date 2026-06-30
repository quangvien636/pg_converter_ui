-- ─── TABLE: Integrated_Replies ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrated_Replies" (
    ReplyNo bigserial NOT NULL,
    ContentNo bigint NOT NULL,
    ModUserNo integer NOT NULL,
    ModUserName character varying(100) NOT NULL,
    ModPositionNo integer NOT NULL,
    ModPositionName character varying(100) NOT NULL,
    ModDepartNo integer NOT NULL,
    ModDepartName character varying(100) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    GroupNo bigint NOT NULL,
    Depth integer NOT NULL,
    OrderNo integer NOT NULL,
    Content text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
