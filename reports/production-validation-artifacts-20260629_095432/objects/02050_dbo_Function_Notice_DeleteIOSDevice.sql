-- ─── FUNCTION: notice_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.notice_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Notice_IOSDevices WHERE UserNo = notice_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
