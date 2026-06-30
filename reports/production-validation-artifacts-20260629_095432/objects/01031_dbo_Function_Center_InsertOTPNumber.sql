-- ─── FUNCTION: center_insertotpnumber ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertotpnumber(integer, bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertotpnumber(
    userno integer,
    deviceno bigint,
    expirationtime timestamp without time zone
) RETURNS TABLE(
    userno text,
    deviceno text,
    number text,
    expirationtime text
)
AS $function$
DECLARE
    number character varying;
    count integer;
BEGIN




	SET Number = ''
	SET Count = 0

	WHILE Count < 6 BEGIN

		SET Number += CONVERT(VARCHAR, ROUND(RAND() * 9, 0))
		SET Count = Count + 1

	END
	
	DELETE FROM Center_OTPNumbers WHERE UserNo = center_insertotpnumber.userno

	INSERT INTO Center_OTPNumbers (UserNo, DeviceNo, Number, ExpirationTime)
	VALUES (UserNo, DeviceNo, Number, ExpirationTime)
	
	RETURN QUERY
	SELECT UserNo, DeviceNo, Number, ExpirationTime
	FROM Center_OTPNumbers
	WHERE UserNo = center_insertotpnumber.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
