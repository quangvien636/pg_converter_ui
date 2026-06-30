-- ─── FUNCTION: dday_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.dday_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_IOSDevices WHERE UserNo = dday_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
