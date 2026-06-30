-- ─── TABLE: Main_DefaultUserSettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_DefaultUserSettings" (
    SettingName character varying(100) NOT NULL PRIMARY KEY,
    SettingValue character varying(100) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
