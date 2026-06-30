-- ─── FUNCTION: deletefilebycontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.deletefilebycontent(bigint);
CREATE OR REPLACE FUNCTION public.deletefilebycontent(
    contentno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE ContentNo = deletefilebycontent.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
