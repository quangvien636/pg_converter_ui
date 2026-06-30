-- ─── TABLE: BSLG_SpAuthInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_SpAuthInfo" (
    PermissionNo serial NOT NULL,
    UserId character varying(100),
    SharedUserId character varying(100),
    SharedDepartNo integer NOT NULL,
    UserofDepart character varying(10),
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
