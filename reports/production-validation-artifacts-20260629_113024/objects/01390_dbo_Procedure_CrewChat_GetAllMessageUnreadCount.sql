-- ─── PROCEDURE→FUNCTION: crewchat_getallmessageunreadcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getallmessageunreadcount(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getallmessageunreadcount(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COUNT(*) AS UnReadCount FROM CrewChat_CheckMessage C
	INNER JOIN CrewChat_RoomUsers R ON 
	R.UserNo = crewchat_getallmessageunreadcount.userno AND R.Closed = 0 AND R.RoomNo = C.RoomNo
	AND R.StartMessageNo <= C.MessageNo
	WHERE C.UserNo = crewchat_getallmessageunreadcount.userno AND C.IsRead = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
