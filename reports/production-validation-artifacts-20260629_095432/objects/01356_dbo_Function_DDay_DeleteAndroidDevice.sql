-- ─── FUNCTION: dday_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.dday_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_AndroidDevices WHERE UserNo = dday_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
