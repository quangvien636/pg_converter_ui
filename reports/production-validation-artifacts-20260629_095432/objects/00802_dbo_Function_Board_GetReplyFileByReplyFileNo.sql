-- ─── FUNCTION: board_getreplyfilebyreplyfileno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getreplyfilebyreplyfileno(bigint);
CREATE OR REPLACE FUNCTION public.board_getreplyfilebyreplyfileno(
    replyfileno bigint DEFAULT 7744
) RETURNS TABLE(
    replyfileno text,
    replyno text,
    name text,
    size text,
    url text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ReplyFileNo,ReplyNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_ReplyFiles
	WHERE ReplyFileNo = board_getreplyfilebyreplyfileno.replyfileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
