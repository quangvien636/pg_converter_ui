-- ─── FUNCTION: center_deleteallnotificationdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteallnotificationdata();
CREATE OR REPLACE FUNCTION public.center_deleteallnotificationdata(
) RETURNS void
AS $function$
BEGIN

	
	DELETE FROM Center_NotificationData;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
