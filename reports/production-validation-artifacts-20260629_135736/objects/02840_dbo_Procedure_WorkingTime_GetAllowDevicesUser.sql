-- ─── PROCEDURE→FUNCTION: workingtime_getallowdevicesuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getallowdevicesuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getallowdevicesuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

     DELETE FROM WorkingTime_AllowDevices where DeviceId  ILIKE '%0000-0000%';
	IF (SELECT COUNT(*) FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_getallowdevicesuser.userno) = 0 THEN

		INSERT INTO WorkingTime_AllowDevices (DepartNo, UserNo, ContentAllow, ModDate, RegDate,IsUserFull)
		VALUES (0, UserNo, '[{"Device":"PC","Allow":true},{"Device":"MOBILE","Allow":true}]', NOW(), NOW(),0)
	END IF;
	
	RETURN QUERY
	SELECT *
	FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_getallowdevicesuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
