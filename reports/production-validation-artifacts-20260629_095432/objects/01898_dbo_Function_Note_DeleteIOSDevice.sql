-- ─── FUNCTION: note_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.note_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Note_IOSDevices WHERE UserNo = note_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
