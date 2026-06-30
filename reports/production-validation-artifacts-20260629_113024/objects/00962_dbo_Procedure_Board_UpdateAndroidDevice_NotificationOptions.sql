-- ─── PROCEDURE→FUNCTION: board_updateandroiddevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateandroiddevice_notificationoptions(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_updateandroiddevice_notificationoptions(
    IN userno integer DEFAULT 70,
    IN deviceid character varying DEFAULT 'cQXYrFi-zgI:APA91bFO_-wi3QTdAe11ZOORe4FKXLHTqNDzxRMlEaciOT2ArI1Jht1-Z8jd2uaQ32i3mk5HdCPF4CN_pQTZJrPQ7_wbZsVvVEPaJ2_AfT9h9UMokm-UaJQ',
    IN notificationoptions character varying DEFAULT '{\"enabled\": true,\"sound\": true,\"vibrate\": true,\"notitime\": false,\"starttime\": \"08:00\",\"endtime\": \"18:00\"}'
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_AndroidDevices SET
		NotificationOptions = board_updateandroiddevice_notificationoptions.notificationoptions
	WHERE UserNo = board_updateandroiddevice_notificationoptions.userno AND DeviceID = board_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
