-- ─── FUNCTION: board_getreplyfilebyreplyno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getreplyfilebyreplyno(bigint);
CREATE OR REPLACE FUNCTION public.board_getreplyfilebyreplyno(
    replyno bigint DEFAULT 0
) RETURNS TABLE(
    replyfileno text,
    name text,
    size text,
    url text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ReplyFileNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_ReplyFiles
	WHERE ReplyNo = board_getreplyfilebyreplyno.replyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
