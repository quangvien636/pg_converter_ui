-- ─── TABLE: CrewChat_Rooms ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_Rooms" (
    RoomNo bigserial NOT NULL,
    MakeUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    IsOne boolean NOT NULL,
    LastedMsg text,
    LastedMsgDate timestamp without time zone,
    LastedMsgNo bigint,
    LastedMsgType integer,
    LastedMsgAttachNo integer,
    LastedMsgAttachType integer,
    LastedMsgAttachName character varying(300),
    RoomType integer,
    GroupType integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
