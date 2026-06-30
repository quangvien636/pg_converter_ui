-- ─── TABLE: WCHATContents ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WCHATContents" (
    ContentNo serial NOT NULL,
    ChatNo integer NOT NULL,
    Content text,
    UserNo integer,
    IsAttach boolean,
    AttachNo integer,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
