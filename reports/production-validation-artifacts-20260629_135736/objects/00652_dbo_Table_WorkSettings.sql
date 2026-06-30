-- ─── TABLE: WorkSettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkSettings" (
    SettingNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    SettingValue character varying(100) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
