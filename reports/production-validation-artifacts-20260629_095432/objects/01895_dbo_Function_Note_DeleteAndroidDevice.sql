-- ─── FUNCTION: note_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.note_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Note_AndroidDevices WHERE UserNo = note_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
