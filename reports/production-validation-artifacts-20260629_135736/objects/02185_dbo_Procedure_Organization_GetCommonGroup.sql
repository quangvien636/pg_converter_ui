-- ─── PROCEDURE→FUNCTION: organization_getcommongroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getcommongroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_getcommongroup(
    IN groupno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ModUserNo, ModDate, Name, SortNo, ListOfUsers
	FROM Organization_CommonGroups
	WHERE GroupNo = organization_getcommongroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
