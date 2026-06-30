-- ─── FUNCTION: board_getfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getfile(bigint);
CREATE OR REPLACE FUNCTION public.board_getfile(
    fileno bigint DEFAULT 592
) RETURNS TABLE(
    contentno text,
    name text,
    size text,
    url text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ContentNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_Files
	WHERE FileNo = board_getfile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
