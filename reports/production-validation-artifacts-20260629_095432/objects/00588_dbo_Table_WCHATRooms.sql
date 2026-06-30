-- ─── TABLE: WCHATRooms ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WCHATRooms" (
    ChatNo serial NOT NULL,
    MakeUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    IsClose boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
