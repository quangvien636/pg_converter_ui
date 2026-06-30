-- ─── TABLE: Authority_SitePermissions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Authority_SitePermissions" (
    UserNo integer NOT NULL PRIMARY KEY,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    PermissionType integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
