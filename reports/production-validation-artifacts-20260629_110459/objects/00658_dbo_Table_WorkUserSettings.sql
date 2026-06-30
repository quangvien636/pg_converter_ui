-- ─── TABLE: WorkUserSettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkUserSettings" (
    UserNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    PermissionLevel integer NOT NULL,
    IsDisplay boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
