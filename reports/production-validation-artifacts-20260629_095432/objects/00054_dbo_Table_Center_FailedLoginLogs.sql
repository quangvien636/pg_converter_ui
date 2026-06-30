-- ─── TABLE: Center_FailedLoginLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_FailedLoginLogs" (
    LogNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    ClientIP character varying(50) NOT NULL,
    FailedLoginDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
