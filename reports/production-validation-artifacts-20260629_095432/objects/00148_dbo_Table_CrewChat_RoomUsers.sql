-- ─── TABLE: CrewChat_RoomUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_RoomUsers" (
    RoomUserNo bigserial NOT NULL,
    RoomNo bigint NOT NULL,
    UserNo integer NOT NULL,
    RoomTitle character varying(200) NOT NULL,
    StartMessageNo bigint NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Notification boolean NOT NULL,
    Closed boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
