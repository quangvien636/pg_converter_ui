-- ─── TABLE: Center_PCSessions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_PCSessions" (
    SessionNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    SessionID character(32) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
