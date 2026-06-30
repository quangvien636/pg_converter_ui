-- ─── FUNCTION: center_deletenotificationdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletenotificationdata(bigint);
CREATE OR REPLACE FUNCTION public.center_deletenotificationdata(
    notificationno bigint
) RETURNS void
AS $function$
BEGIN

	
	DELETE FROM Center_NotificationData WHERE NotificationNo = center_deletenotificationdata.notificationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
