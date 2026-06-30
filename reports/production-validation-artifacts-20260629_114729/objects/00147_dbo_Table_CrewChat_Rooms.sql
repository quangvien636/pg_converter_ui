-- ─── TABLE: CrewChat_Rooms ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_Rooms" (
    RoomNo bigserial NOT NULL,
    MakeUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    IsOne boolean NOT NULL DEFAULT true,
    LastedMsg text DEFAULT '',
    LastedMsgDate timestamp without time zone,
    LastedMsgNo bigint DEFAULT 0,
    LastedMsgType integer DEFAULT -1,
    LastedMsgAttachNo integer DEFAULT 0,
    LastedMsgAttachType integer DEFAULT 0,
    LastedMsgAttachName character varying(300) DEFAULT '',
    RoomType integer DEFAULT 0,
    GroupType integer DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
