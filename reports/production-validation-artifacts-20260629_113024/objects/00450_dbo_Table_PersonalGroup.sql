-- ─── TABLE: PersonalGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."PersonalGroup" (
    GroupNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    GroupName character varying(50) NOT NULL,
    Description character varying(500) NOT NULL DEFAULT '',
    ShareType character(1) NOT NULL,
    DepartNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
