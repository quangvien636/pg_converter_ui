-- ─── TABLE: CrewChat_PCSessions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_PCSessions" (
    SessionNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    SessionID character(32) NOT NULL,
    DeviceNo bigint NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
