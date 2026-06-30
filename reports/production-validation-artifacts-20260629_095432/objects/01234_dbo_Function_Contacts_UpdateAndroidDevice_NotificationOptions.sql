-- ─── FUNCTION: contacts_updateandroiddevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updateandroiddevice_notificationoptions(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_updateandroiddevice_notificationoptions(
    userno integer DEFAULT 70,
    deviceid character varying DEFAULT 'cQXYrFi-zgI:APA91bFO_-wi3QTdAe11ZOORe4FKXLHTqNDzxRMlEaciOT2ArI1Jht1-Z8jd2uaQ32i3mk5HdCPF4CN_pQTZJrPQ7_wbZsVvVEPaJ2_AfT9h9UMokm-UaJQ',
    notificationoptions character varying DEFAULT '{\"enabled\": true,\"sound\": true,\"vibrate\": true,\"notitime\": false,\"starttime\": \"08:00\",\"endtime\": \"18:00\"}'
) RETURNS void
AS $function$
BEGIN


	UPDATE _AndroidDevices SET
		NotificationOptions = contacts_updateandroiddevice_notificationoptions.notificationoptions
	WHERE UserNo = contacts_updateandroiddevice_notificationoptions.userno AND DeviceID = contacts_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
