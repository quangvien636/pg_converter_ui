-- ─── TABLE: WorkingTimeV2_Types ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTimeV2_Types" (
    TypeNo integer NOT NULL PRIMARY KEY,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    TypeName character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
