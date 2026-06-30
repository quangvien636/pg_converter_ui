-- ─── TABLE: VOTESettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTESettings" (
    SettingNo serial NOT NULL,
    SettingCd character varying(30) NOT NULL,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    SettingValue character varying(200) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
