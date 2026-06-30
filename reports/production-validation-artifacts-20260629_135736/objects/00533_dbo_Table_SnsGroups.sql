-- ─── TABLE: SnsGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsGroups" (
    GroupNo serial NOT NULL,
    GroupName character varying(200),
    MakeUserNo integer,
    GroupType integer,
    RegDate timestamp without time zone DEFAULT now(),
    OpenType integer DEFAULT 0,
    Enabled boolean DEFAULT true,
    DepartNo integer DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
