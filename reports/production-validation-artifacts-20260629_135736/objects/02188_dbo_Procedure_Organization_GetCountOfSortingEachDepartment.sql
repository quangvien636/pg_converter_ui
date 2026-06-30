-- ─── PROCEDURE→FUNCTION: organization_getcountofsortingeachdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getcountofsortingeachdepartment(integer);
CREATE OR REPLACE FUNCTION public.organization_getcountofsortingeachdepartment(
    IN departno integer
) RETURNS SETOF record
AS $function$
DECLARE
    count integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	Count := (SELECT COUNT(*) FROM Organization_SortingEachDepartment WHERE DepartNo = organization_getcountofsortingeachdepartment.departno);
	RETURN QUERY
	SELECT COALESCE(Count, 0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
