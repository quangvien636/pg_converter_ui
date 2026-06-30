-- ─── TABLE: Center_NotificationData ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_NotificationData" (
    NotificationNo bigserial NOT NULL,
    DeviceType character varying(50),
    ModuleName character varying(200),
    ProjectID character varying(500),
    DeviceKey character varying(1000),
    JsonData text,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
