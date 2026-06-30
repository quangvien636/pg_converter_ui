-- ─── FUNCTION: dday_deletenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletenotification(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletenotification(
    notino bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Notifications WHERE NotiNo = dday_deletenotification.notino;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
