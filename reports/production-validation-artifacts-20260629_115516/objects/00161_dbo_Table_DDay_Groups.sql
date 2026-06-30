-- ─── TABLE: DDay_Groups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_Groups" (
    GroupNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    TagNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    SortNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
