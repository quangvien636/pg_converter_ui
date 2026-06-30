-- ─── FUNCTION: board_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.board_getfiles(
    contentno bigint DEFAULT 5793
) RETURNS TABLE(
    fileno text,
    name text,
    size text,
    url text,
    sort text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Size,COALESCE(Url,'') AS Url,Sort
	FROM Board_Files
	WHERE ContentNo = board_getfiles.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
