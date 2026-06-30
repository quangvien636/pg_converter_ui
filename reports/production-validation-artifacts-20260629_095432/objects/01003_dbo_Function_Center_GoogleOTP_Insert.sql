-- ─── FUNCTION: center_googleotp_insert ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_googleotp_insert(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_googleotp_insert(
    userid character varying,
    otpsetupkey character varying,
    qrcodesetupimageurl character varying
) RETURNS void
AS $function$
DECLARE
    cnt integer;
BEGIN


	SET CNT = (SELECT COUNT(*) FROM Center_GoogleOTPInfo WHERE UserID=center_googleotp_insert.userid)
	IF CNT = 0
	BEGIN;
		INSERT INTO Center_GoogleOTPInfo (UserID, OTPSetUpKey, QrCodeSetupImageUrl, ManualEntryKey, RegDate) VALUES
		(UserID, OTPSetUpKey, QrCodeSetupImageUrl, ManualEntryKey, NOW())
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
