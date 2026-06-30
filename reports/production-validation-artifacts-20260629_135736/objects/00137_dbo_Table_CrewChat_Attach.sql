-- ─── TABLE: CrewChat_Attach ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_Attach" (
    AttachNo serial NOT NULL,
    FileName character varying(300) NOT NULL,
    FullPath character varying(1000) NOT NULL,
    Type integer NOT NULL,
    Size bigint NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ThumPath character varying(1000),
    ThumbWidth integer NOT NULL DEFAULT 0,
    ThumbHeight integer NOT NULL DEFAULT 0,
    RoomNo bigint
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
