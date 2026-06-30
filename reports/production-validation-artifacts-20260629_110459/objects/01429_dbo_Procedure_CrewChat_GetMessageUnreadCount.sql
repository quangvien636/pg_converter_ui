-- ─── PROCEDURE→FUNCTION: crewchat_getmessageunreadcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getmessageunreadcount(bigint, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getmessageunreadcount(
    IN roomno bigint,
    IN startmsgno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT M.MessageNo, 
	(SELECT COUNT(CheckNo) FROM CrewChat_CheckMessage C 
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
	FROM CrewChat_Messages M
	WHERE M.RoomNo = crewchat_getmessageunreadcount.roomno AND M.MessageNo >= crewchat_getmessageunreadcount.startmsgno
	ORDER BY M.RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
