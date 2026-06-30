-- ─── PROCEDURE→FUNCTION: organization_getpersonalgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getpersonalgroups(integer);
CREATE OR REPLACE FUNCTION public.organization_getpersonalgroups(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT GroupNo, UserNo, ModDate, Name, SortNo
	FROM Organization_PersonalGroups
	WHERE UserNo = organization_getpersonalgroups.userno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
