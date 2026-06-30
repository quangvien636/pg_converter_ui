-- ─── TABLE: CrewChat_Messages ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_Messages" (
    MessageNo bigserial NOT NULL,
    RoomNo bigint NOT NULL,
    UserNo integer NOT NULL,
    Message text NOT NULL,
    Type integer NOT NULL,
    AttachNo integer NOT NULL,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
