-- ─── TABLE: EAPPSMTPEnv ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPSMTPEnv" (
    UserNo integer NOT NULL PRIMARY KEY,
    ID character varying(50) NOT NULL,
    PW character varying(100) NOT NULL,
    Name character varying(50) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
