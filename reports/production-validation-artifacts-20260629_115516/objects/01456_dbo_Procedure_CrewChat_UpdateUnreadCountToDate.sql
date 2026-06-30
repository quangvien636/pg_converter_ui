-- ─── PROCEDURE→FUNCTION: crewchat_updateunreadcounttodate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_updateunreadcounttodate(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_updateunreadcounttodate(
    IN roomno bigint,
    IN userno integer,
    IN basedate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	UPDATE CrewChat_CheckMessage SET IsRead = TRUE, ModDate=NOW()
	WHERE RoomNo = crewchat_updateunreadcounttodate.roomno AND UserNo = crewchat_updateunreadcounttodate.userno AND IsRead != 1
	AND RegDate <= crewchat_updateunreadcounttodate.basedate
	--AND RegDate >= BaseDate
	
	RETURN QUERY
	SELECT @ROWCOUNT AS COUNT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
