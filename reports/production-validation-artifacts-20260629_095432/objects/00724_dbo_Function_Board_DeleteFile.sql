-- ─── FUNCTION: board_deletefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletefile(bigint);
CREATE OR REPLACE FUNCTION public.board_deletefile(
    fileno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE FileNo = board_deletefile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
