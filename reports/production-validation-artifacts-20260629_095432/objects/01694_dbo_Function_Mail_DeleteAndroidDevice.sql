-- ─── FUNCTION: mail_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.mail_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_AndroidDevices WHERE UserNo = mail_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
