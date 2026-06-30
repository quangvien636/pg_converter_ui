-- ─── FUNCTION: main_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.main_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_IOSDevices WHERE UserNo = main_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
