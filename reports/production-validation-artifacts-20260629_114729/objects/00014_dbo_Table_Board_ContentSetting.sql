-- ─── TABLE: Board_ContentSetting ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_ContentSetting" (
    ContentSettingNo serial NOT NULL,
    ContentSetting text,
    BoardNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
