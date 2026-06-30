-- ─── TABLE: CrewChat_FavoriteGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_FavoriteGroups" (
    GroupNo serial NOT NULL,
    UserNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
