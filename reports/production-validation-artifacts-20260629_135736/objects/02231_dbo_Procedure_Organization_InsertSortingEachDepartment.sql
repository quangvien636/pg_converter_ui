-- ─── PROCEDURE→FUNCTION: organization_insertsortingeachdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertsortingeachdepartment(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.organization_insertsortingeachdepartment(
    IN departno integer,
    IN userno integer,
    IN sortno integer
) RETURNS SETOF record
AS $function$
DECLARE
    datano bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_SortingEachDepartment VALUES (DepartNo, UserNo, SortNo)
	

	DataNo := lastval();
	RETURN QUERY
	SELECT DataNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
