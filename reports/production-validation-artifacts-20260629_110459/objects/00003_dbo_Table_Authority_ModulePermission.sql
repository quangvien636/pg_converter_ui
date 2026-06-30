-- ─── TABLE: Authority_ModulePermission ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Authority_ModulePermission" (
    ModulePermissionNo serial NOT NULL,
    ApplicationNo integer NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    UserofDepart character varying(10),
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
