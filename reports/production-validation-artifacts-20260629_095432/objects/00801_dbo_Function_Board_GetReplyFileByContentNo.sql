-- ─── FUNCTION: board_getreplyfilebycontentno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getreplyfilebycontentno(bigint);
CREATE OR REPLACE FUNCTION public.board_getreplyfilebycontentno(
    contentno bigint DEFAULT 5158
) RETURNS TABLE(
    replyno text,
    replyfileno text,
    name text,
    size text,
    url text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT BR.ReplyNo, RF.ReplyFileNo, RF.Name, RF.Size,COALESCE(RF.Url,'') AS Url
	FROM Board_ReplyFiles RF
	INNER JOIN Board_Replies BR ON BR.ReplyNo=RF.ReplyNo 
	WHERE BR.ContentNo = board_getreplyfilebycontentno.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
