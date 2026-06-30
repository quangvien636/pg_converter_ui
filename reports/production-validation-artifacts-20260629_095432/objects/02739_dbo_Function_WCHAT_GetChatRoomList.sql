-- ─── FUNCTION: wchat_getchatroomlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_getchatroomlist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomlist(
    userno integer,
    type integer,
    viewcount integer
) RETURNS TABLE(
    rownum text,
    chatno text,
    makeuserno text,
    regdate text,
    content text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	IF Type = 0		--사용자
	BEGIN
		RETURN QUERY
		SELECT ChatNo, MakeUserNo, RegDate, Title,
		(SELECT COUNT(*) FROM WCHATMembers MM INNER JOIN WCHATRooms RR ON RR.ChatNo=MM.ChatNo AND RR.IsClose = FALSE WHERE MM.UserNo=wchat_getchatroomlist.userno) AS TotalCnt
		FROM
		(SELECT (ROW_NUMBER() OVER (ORDER BY R.RegDate ASC)) AS RowNum, R.ChatNo, R.MakeUserNo, R.RegDate,
		COALESCE((SELECT /* TOP 1 */ C.Content FROM WCHATContents C WHERE C.ChatNo=R.ChatNo ORDER BY C.RegDate DESC), '') AS Title
		FROM WCHATMembers M
		INNER JOIN WCHATRooms R ON R.ChatNo = M.ChatNo
		WHERE M.UserNo = wchat_getchatroomlist.userno AND R.IsClose = FALSE) 
		T
		WHERE 
		T.RowNum BETWEEN 
		((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		ORDER BY RegDate ASC
	END
	ELSE IF Type = 1	--전체
	BEGIN
		RETURN QUERY
		SELECT ChatNo, MakeUserNo, RegDate, Title FROM
		(SELECT (ROW_NUMBER() OVER (ORDER BY R.RegDate ASC)) AS RowNum, R.ChatNo, R.MakeUserNo, R.RegDate,
		COALESCE((SELECT /* TOP 1 */ C.Content FROM WCHATContents C WHERE C.ChatNo=R.ChatNo ORDER BY C.RegDate DESC), '') AS Title
		FROM WCHATMembers M
		INNER JOIN WCHATRooms R ON R.ChatNo = M.ChatNo
		WHERE R.IsClose = FALSE) 
		T
		WHERE 
		T.RowNum BETWEEN 
		((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		ORDER BY RegDate ASC
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
