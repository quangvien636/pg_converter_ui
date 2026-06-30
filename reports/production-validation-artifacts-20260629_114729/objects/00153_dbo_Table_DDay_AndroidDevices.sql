-- ─── TABLE: DDay_AndroidDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_AndroidDevices" (
    DeviceNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    DeviceID character varying(2000) NOT NULL,
    OSVersion character varying(100) NOT NULL,
    NotificationOptions character varying(1000) NOT NULL,
    TimezoneOffset integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
