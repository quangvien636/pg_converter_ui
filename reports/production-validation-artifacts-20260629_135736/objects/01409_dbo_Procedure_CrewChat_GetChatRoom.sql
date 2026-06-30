-- ─── PROCEDURE→FUNCTION: crewchat_getchatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getchatroom(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroom(
    IN roomno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT RoomNo, MakeUserNo, ModDate, IsOne, RoomType FROM CrewChat_Rooms
	WHERE RoomNo = crewchat_getchatroom.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
