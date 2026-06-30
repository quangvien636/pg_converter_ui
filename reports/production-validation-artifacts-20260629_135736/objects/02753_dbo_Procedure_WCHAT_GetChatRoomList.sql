-- ─── PROCEDURE→FUNCTION: wchat_getchatroomlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.wchat_getchatroomlist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomlist(
    IN userno integer,
    IN type integer,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF Type = 0		--사용자 THEN
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
	END IF;
	ELSIF Type = 1	--전체 THEN
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
