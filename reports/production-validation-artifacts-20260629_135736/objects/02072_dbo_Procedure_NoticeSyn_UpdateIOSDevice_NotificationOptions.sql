-- ─── PROCEDURE→FUNCTION: noticesyn_updateiosdevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updateiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_updateiosdevice_notificationoptions(
    IN userno integer,
    IN deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_IOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = noticesyn_updateiosdevice_notificationoptions.userno AND DeviceID = noticesyn_updateiosdevice_notificationoptions.deviceid

END;

-------------------------/////////////////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
