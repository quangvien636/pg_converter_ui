-- ─── TABLE: Center_AccessLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_AccessLogs" (
    LogNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    ClientIP character varying(50) NOT NULL,
    AccessDate timestamp without time zone NOT NULL,
    ApplicationNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
