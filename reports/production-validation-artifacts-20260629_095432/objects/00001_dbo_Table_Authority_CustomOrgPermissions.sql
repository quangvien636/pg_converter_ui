-- ─── TABLE: Authority_CustomOrgPermissions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Authority_CustomOrgPermissions" (
    UserNo integer NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    PermissionType integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
