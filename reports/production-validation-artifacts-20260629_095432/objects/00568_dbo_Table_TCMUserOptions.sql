-- ─── TABLE: TCMUserOptions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMUserOptions" (
    UserNo integer NOT NULL PRIMARY KEY,
    IsAllUserSearch character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
