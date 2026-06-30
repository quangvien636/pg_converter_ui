-- ─── TABLE: WCHATContents ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WCHATContents" (
    ContentNo serial NOT NULL,
    ChatNo integer NOT NULL,
    Content text,
    UserNo integer,
    IsAttach boolean DEFAULT false,
    AttachNo integer DEFAULT 0,
    RegDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
