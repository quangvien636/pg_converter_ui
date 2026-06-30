-- ─── TABLE: Center_OTPNumbers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_OTPNumbers" (
    UserNo integer NOT NULL PRIMARY KEY,
    DeviceNo bigint NOT NULL,
    Number character(6) NOT NULL,
    ExpirationTime timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
