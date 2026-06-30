-- ─── TABLE: SnsMessages ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsMessages" (
    MessageNo serial NOT NULL,
    UserNo integer,
    GroupNo integer,
    RegDate timestamp without time zone,
    Message character varying(8000),
    IsAttach boolean,
    IsPicture boolean,
    IsShare boolean,
    ShareContentNo integer,
    IsDelete boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
