-- ─── PROCEDURE→FUNCTION: authority_listmodulepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.authority_listmodulepermission(integer);
CREATE OR REPLACE FUNCTION public.authority_listmodulepermission(
    IN applicationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT ModulePermissionNo,ApplicationNo,
	case when UserofDepart = 'user' then B.UserNo else B.DepartNo end Code
	,case when UserofDepart = 'user' then U.Name else D.Name end Name
	,UserofDepart,RegUserNo,RegDate 
	FROM Authority_ModulePermission B
	LEFT JOIN Organization_Users U ON U.UserNo = B.UserNo and B.UserofDepart = 'user'
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo and B.UserofDepart = 'depart'
	WHERE ApplicationNo = authority_listmodulepermission.applicationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
