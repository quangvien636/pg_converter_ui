-- ─── FUNCTION: center_deletenotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletenotificationservice(bigint);
CREATE OR REPLACE FUNCTION public.center_deletenotificationservice(
    notificationno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_NotificationService where NotificationNo = center_deletenotificationservice.notificationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
