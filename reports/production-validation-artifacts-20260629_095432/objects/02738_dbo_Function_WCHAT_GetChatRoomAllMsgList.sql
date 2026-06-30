-- ─── FUNCTION: wchat_getchatroomallmsglist ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_getchatroomallmsglist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomallmsglist(
    chatno integer,
    mode integer,
    viewcount integer
) RETURNS TABLE(
    contentno text,
    chatno text,
    content text,
    userno text,
    isattach text,
    attachno text,
    regdate text
)
AS $function$
BEGIN


	
	IF Mode = 0
	BEGIN
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM
	(SELECT (ROW_NUMBER() OVER (ORDER BY RegDate DESC)) AS RowNum, ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ChatNo = wchat_getchatroomallmsglist.chatno) 
	T WHERE 
	T.RowNum BETWEEN 
	((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
	ORDER BY RegDate ASC
	END
	ELSE IF Mode = 1
	BEGIN
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ChatNo = wchat_getchatroomallmsglist.chatno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
