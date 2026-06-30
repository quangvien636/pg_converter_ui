-- ─── TABLE: EDMSUserEnv ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSUserEnv" (
    UserID character varying(50),
    ApplyAllList character(1),
    AuthorityLevel character varying(3),
    AdminFlag character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
