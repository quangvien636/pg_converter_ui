-- ─── TABLE: CustomOrg_AuthInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CustomOrg_AuthInfo" (
    PermissionNo serial NOT NULL,
    UserNo integer NOT NULL,
    SharedDepartNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
