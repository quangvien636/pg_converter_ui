-- ─── PROCEDURE→FUNCTION: noticesyn_getiosdeviceofallusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getiosdeviceofallusers();
CREATE OR REPLACE FUNCTION public.noticesyn_getiosdeviceofallusers(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN NoticeSyn_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	
END;
------------------------/////////////////////////////// ----------------------------
--- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
