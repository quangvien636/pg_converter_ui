-- ─── TABLE: SnsGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsGroups" (
    GroupNo serial NOT NULL,
    GroupName character varying(200),
    MakeUserNo integer,
    GroupType integer,
    RegDate timestamp without time zone,
    OpenType integer,
    Enabled boolean,
    DepartNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
