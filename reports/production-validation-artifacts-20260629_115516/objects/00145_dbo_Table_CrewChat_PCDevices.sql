-- ─── TABLE: CrewChat_PCDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_PCDevices" (
    DeviceNo bigserial NOT NULL,
    SerialNumber character(32) NOT NULL,
    MacAddress character(16) NOT NULL,
    Allow boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
