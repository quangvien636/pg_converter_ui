-- ─── TABLE: Center_Sessions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_Sessions" (
    UserNo integer NOT NULL,
    UserID character varying(100) NOT NULL,
    SessionID character(32) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
