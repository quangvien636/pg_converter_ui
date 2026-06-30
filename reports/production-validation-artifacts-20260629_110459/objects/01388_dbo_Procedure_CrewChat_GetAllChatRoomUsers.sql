-- ─── PROCEDURE→FUNCTION: crewchat_getallchatroomusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getallchatroomusers();
CREATE OR REPLACE FUNCTION public.crewchat_getallchatroomusers(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT U.RoomNo, U.UserNo 
	FROM CrewChat_RoomUsers U
	INNER JOIN CrewChat_Rooms R ON R.RoomNo = U.RoomNo
	WHERE R.GroupType = 0 AND R.LastedMsgNo > 0
	ORDER BY RoomNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
