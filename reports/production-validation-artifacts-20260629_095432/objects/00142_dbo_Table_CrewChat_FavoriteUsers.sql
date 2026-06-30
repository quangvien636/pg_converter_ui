-- ─── TABLE: CrewChat_FavoriteUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_FavoriteUsers" (
    GroupUserNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    GroupNo integer NOT NULL,
    UserNo integer NOT NULL,
    SortNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
