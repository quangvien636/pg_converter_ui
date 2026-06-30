-- ─── TABLE: Center_MobileDevicesAccessrestrictions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_MobileDevicesAccessrestrictions" (
    DeviceNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    mobileType character varying(100) NOT NULL,
    OSVersion character varying(100) NOT NULL,
    ModuleName character varying(100) NOT NULL,
    DeviceId character varying(1000) NOT NULL,
    DeviceName character varying(100) NOT NULL,
    UUID character varying(1000) NOT NULL,
    Enabled boolean NOT NULL,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
