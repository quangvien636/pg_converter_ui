-- ─── TABLE: SnsGroupUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsGroupUsers" (
    GroupUserNo serial NOT NULL,
    GroupNo integer NOT NULL,
    UserNo integer,
    IsJoin boolean,
    IsBookmark boolean,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
