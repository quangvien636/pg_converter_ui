-- ─── TABLE: SnsMessages ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsMessages" (
    MessageNo serial NOT NULL,
    UserNo integer,
    GroupNo integer,
    RegDate timestamp without time zone DEFAULT now(),
    Message character varying(8000),
    IsAttach boolean DEFAULT false,
    IsPicture boolean DEFAULT false,
    IsShare boolean DEFAULT false,
    ShareContentNo integer DEFAULT 0,
    IsDelete boolean DEFAULT false
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
