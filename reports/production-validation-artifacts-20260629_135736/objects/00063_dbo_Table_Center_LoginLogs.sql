-- ─── TABLE: Center_LoginLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_LoginLogs" (
    LogNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    ClientIP character varying(50) NOT NULL,
    LoginDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
