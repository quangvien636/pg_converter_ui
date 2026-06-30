-- ─── TABLE: Drive_UserConfigurations ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_UserConfigurations" (
    UserNo integer NOT NULL PRIMARY KEY,
    MaxLengthForMyDrive bigint NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
