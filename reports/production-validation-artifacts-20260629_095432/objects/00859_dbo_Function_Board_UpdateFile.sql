-- ─── FUNCTION: board_updatefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatefile(bigint, bigint, character varying, bigint);
CREATE OR REPLACE FUNCTION public.board_updatefile(
    fileno bigint,
    contentno bigint,
    name character varying,
    size bigint
) RETURNS TABLE(
    fileno text
)
AS $function$
BEGIN


	Update Board_Files 
	SET ContentNo=board_updatefile.contentno,Name=board_updatefile.name,Size=board_updatefile.size,Url=FilePath
	WHERE FileNo=board_updatefile.fileno
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
