-- ─── PROCEDURE→FUNCTION: wchat_getchatroomallmsglist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_getchatroomallmsglist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomallmsglist(
    IN chatno integer,
    IN mode integer,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF Mode = 0 THEN
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM
	(SELECT (ROW_NUMBER() OVER (ORDER BY RegDate DESC)) AS RowNum, ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ChatNo = wchat_getchatroomallmsglist.chatno) 
	T WHERE 
	T.RowNum BETWEEN 
	((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
	ORDER BY RegDate ASC
	END IF;
	ELSIF Mode = 1 THEN
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ChatNo = wchat_getchatroomallmsglist.chatno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
