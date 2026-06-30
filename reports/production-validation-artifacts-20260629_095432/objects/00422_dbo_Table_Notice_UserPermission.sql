-- ─── TABLE: Notice_UserPermission ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Notice_UserPermission" (
    UserPermissionId serial NOT NULL,
    UserNo integer NOT NULL,
    CategoryId integer NOT NULL,
    Permission integer NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ViewEndDate integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
