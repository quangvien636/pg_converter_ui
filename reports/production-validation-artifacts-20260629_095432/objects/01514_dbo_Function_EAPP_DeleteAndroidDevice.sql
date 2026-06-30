-- ─── FUNCTION: eapp_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.eapp_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM EAPP_AndroidDevices WHERE UserNo = eapp_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
