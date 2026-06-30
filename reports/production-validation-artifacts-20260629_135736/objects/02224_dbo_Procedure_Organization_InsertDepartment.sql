-- ─── PROCEDURE→FUNCTION: organization_insertdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertdepartment(integer, timestamp without time zone, integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertdepartment(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN parentno integer,
    IN name character varying,
    IN name_en character varying,
    IN shortname character varying,
    IN enabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SortNo := (COALESCE(max(SortNo) + 1,1) from Organization_Departments  where  ParentNo = organization_insertdepartment.parentno);;
	INSERT INTO Organization_Departments (ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled)
	VALUES (ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled)
	

	DepartNo := lastval();
	RETURN QUERY
	SELECT DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
