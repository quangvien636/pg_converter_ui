-- ─── PROCEDURE→FUNCTION: center_insertotpnumber ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertotpnumber(integer, bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertotpnumber(
    IN userno integer,
    IN deviceno bigint,
    IN expirationtime timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    number character varying;
    count integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	Number := '';
	Count := 0;
	WHILE Count < 6 LOOP

		SET Number += CONVERT(VARCHAR, ROUND(RAND() * 9, 0))
		Count := Count + 1;
	END LOOP;
	
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
