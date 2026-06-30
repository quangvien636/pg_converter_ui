-- ─── PROCEDURE→FUNCTION: crewchat_deleteiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.crewchat_deleteiosdevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_IOSDevices
	WHERE UserNo = crewchat_deleteiosdevice.userno AND DeviceID = DeviceID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
