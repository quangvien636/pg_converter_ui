-- ─── PROCEDURE→FUNCTION: center_googleotp_insert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_googleotp_insert(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_googleotp_insert(
    IN userid character varying,
    IN otpsetupkey character varying,
    IN qrcodesetupimageurl character varying
) RETURNS void
AS $function$
DECLARE
    cnt integer;
BEGIN


	CNT := (SELECT COUNT(*) FROM Center_GoogleOTPInfo WHERE UserID=center_googleotp_insert.userid);
	IF CNT = 0 THEN;
		INSERT INTO Center_GoogleOTPInfo (UserID, OTPSetUpKey, QrCodeSetupImageUrl, ManualEntryKey, RegDate) VALUES
		(UserID, OTPSetUpKey, QrCodeSetupImageUrl, ManualEntryKey, NOW())
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
