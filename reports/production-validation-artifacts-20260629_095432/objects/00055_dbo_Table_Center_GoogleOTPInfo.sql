-- ─── TABLE: Center_GoogleOTPInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_GoogleOTPInfo" (
    UserID character varying(100),
    OTPSetUpKey character varying(50),
    QrCodeSetupImageUrl text,
    ManualEntryKey character varying(100),
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
