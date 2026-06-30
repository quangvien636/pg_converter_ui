-- ─── FUNCTION: board_insertreplyfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertreplyfile(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_insertreplyfile(
    replyno bigint,
    name character varying,
    size integer
) RETURNS TABLE(
    replyfileno text
)
AS $function$
DECLARE
    replyfileno bigint;
BEGIN


	INSERT INTO Board_ReplyFiles (ReplyNo, Name, Size,Url)
	VALUES (ReplyNo, Name, Size,FilePath)
	

	SET ReplyFileNo = lastval()
	
	RETURN QUERY
	SELECT ReplyFileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
