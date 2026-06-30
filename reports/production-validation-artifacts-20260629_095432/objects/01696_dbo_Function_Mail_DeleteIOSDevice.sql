-- ─── FUNCTION: mail_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.mail_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_IOSDevices WHERE UserNo = mail_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
