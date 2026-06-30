-- ─── FUNCTION: noticesyn_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM NoticeSyn_AndroidDevices WHERE UserNo = noticesyn_deleteandroiddevice.userno
	
END;

-------------------------------/////////////////////////////-------
------USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
