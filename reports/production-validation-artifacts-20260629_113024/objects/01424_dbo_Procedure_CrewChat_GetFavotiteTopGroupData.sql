-- ─── PROCEDURE→FUNCTION: crewchat_getfavotitetopgroupdata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getfavotitetopgroupdata(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitetopgroupdata(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupUserNo, RegUserNo, GroupNo, UserNo, SortNo, ModDate 
	FROM CrewChat_FavoriteUsers
	WHERE RegUserNo = crewchat_getfavotitetopgroupdata.userno AND GroupNo=0 ORDER BY GroupNo ASC, SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
