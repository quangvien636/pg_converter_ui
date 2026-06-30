-- ─── TABLE: WorkingTime_Settings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Settings" (
    SettingNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    SettingValue character varying(200) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
