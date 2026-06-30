-- ─── TABLE: CrewChat_DeleteRooms ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_DeleteRooms" (
    SEQ_NO serial NOT NULL,
    RoomNo bigint NOT NULL,
    LastedDate timestamp without time zone,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
