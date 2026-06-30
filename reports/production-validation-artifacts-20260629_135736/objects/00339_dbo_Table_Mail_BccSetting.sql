-- ─── TABLE: Mail_BccSetting ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_BccSetting" (
    BccSettingNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    BccUserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
