-- ─── TABLE: Center_MobileDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_MobileDevices" (
    DeviceNo bigserial NOT NULL,
    SerialNumber character(12) NOT NULL,
    OSVersion character varying(100) NOT NULL,
    Allow boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
