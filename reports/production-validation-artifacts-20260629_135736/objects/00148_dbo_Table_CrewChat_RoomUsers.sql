-- ─── TABLE: CrewChat_RoomUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_RoomUsers" (
    RoomUserNo bigserial NOT NULL,
    RoomNo bigint NOT NULL,
    UserNo integer NOT NULL,
    RoomTitle character varying(200) NOT NULL DEFAULT '',
    StartMessageNo bigint NOT NULL DEFAULT 0,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    Notification boolean NOT NULL DEFAULT true,
    Closed boolean NOT NULL DEFAULT false
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
