-- ─── TABLE: CrewChat_FavoriteChatRoom ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_FavoriteChatRoom" (
    FavoriteChatRoomNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RoomNo bigint NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
