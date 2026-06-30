-- ─── TABLE: Center_MobileSessions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_MobileSessions" (
    SessionNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    SessionID character(32) NOT NULL,
    DeviceNo bigint NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
