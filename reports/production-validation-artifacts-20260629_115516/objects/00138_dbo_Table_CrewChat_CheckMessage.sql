-- ─── TABLE: CrewChat_CheckMessage ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_CheckMessage" (
    CheckNo bigserial NOT NULL,
    MessageNo bigint NOT NULL,
    RoomNo bigint NOT NULL,
    UserNo integer NOT NULL,
    IsRead boolean NOT NULL DEFAULT false,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
