-- ─── FUNCTION: center_getotpnumber ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getotpnumber(integer);
CREATE OR REPLACE FUNCTION public.center_getotpnumber(
    userno integer
) RETURNS TABLE(
    userno text,
    deviceno text,
    number text,
    expirationtime text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, DeviceNo, Number, ExpirationTime
	FROM Center_OTPNumbers
	WHERE UserNo = center_getotpnumber.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
