-- ─── TABLE: BSLG_AuthInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_AuthInfo" (
    OrgMgm character varying(1) NOT NULL,
    UsersMgm character varying(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
