-- ─── PROCEDURE→FUNCTION: organization_getpersonalgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getpersonalgroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_getpersonalgroup(
    IN groupno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT UserNo, ModDate, Name, SortNo, ListOfUsers
	FROM Organization_PersonalGroups
	WHERE GroupNo = organization_getpersonalgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
