-- ─── FUNCTION: main_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.main_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_AndroidDevices WHERE UserNo = main_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
