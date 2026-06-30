-- ─── FUNCTION: board_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.board_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Board_IOSDevices WHERE UserNo = board_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
