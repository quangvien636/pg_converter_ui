-- ─── TABLE: SnsGroupUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsGroupUsers" (
    GroupUserNo serial NOT NULL,
    GroupNo integer NOT NULL,
    UserNo integer,
    IsJoin boolean DEFAULT false,
    IsBookmark boolean DEFAULT false,
    RegDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
