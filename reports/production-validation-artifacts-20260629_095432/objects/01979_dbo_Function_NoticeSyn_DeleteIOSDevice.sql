-- ─── FUNCTION: noticesyn_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM NoticeSyn_IOSDevices WHERE UserNo = noticesyn_deleteiosdevice.userno
	
END;
-------------------------------/////////////////////////////--
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
