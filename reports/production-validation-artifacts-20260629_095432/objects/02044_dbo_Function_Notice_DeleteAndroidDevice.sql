-- ─── FUNCTION: notice_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.notice_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Notice_AndroidDevices WHERE UserNo = notice_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
