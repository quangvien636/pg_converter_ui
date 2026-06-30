-- ─── PROCEDURE→FUNCTION: crewchat_deleteandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.crewchat_deleteandroiddevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_AndroidDevices
	WHERE UserNo = crewchat_deleteandroiddevice.userno AND DeviceID = DeviceID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
