-- ─── PROCEDURE→FUNCTION: crewchat_getfavotitegroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getfavotitegroups(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitegroups(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, UserNo, Name, SortNo, ModDate FROM CrewChat_FavoriteGroups
	WHERE UserNo = crewchat_getfavotitegroups.userno ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
