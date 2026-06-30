-- ─── PROCEDURE→FUNCTION: crewchat_getfavotiteusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getfavotiteusers(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotiteusers(
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, UserNo, SortNo, ModDate FROM CrewChat_FavoriteUsers
	WHERE GroupNo = crewchat_getfavotiteusers.groupno ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
