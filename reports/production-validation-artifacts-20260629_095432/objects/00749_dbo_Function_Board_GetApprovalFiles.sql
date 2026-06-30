-- ─── FUNCTION: board_getapprovalfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getapprovalfiles(integer);
CREATE OR REPLACE FUNCTION public.board_getapprovalfiles(
    contentno integer DEFAULT 16
) RETURNS TABLE(
    name text,
    url text
)
AS $function$
BEGIN

RETURN QUERY
SELECT Name,Url FROM Board_Files where ContentNo=board_getapprovalfiles.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
