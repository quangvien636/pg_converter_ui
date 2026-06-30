-- ─── TABLE: Board_UserSetting ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_UserSetting" (
    UserNo integer NOT NULL PRIMARY KEY,
    ModeView integer,
    PageSize integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
