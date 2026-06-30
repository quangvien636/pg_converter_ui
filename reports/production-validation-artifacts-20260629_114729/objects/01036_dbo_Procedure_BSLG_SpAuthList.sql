-- ─── PROCEDURE→FUNCTION: bslg_spauthlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_spauthlist(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthlist(
    IN userid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	RETURN QUERY
	SELECT PermissionNo,
	SharedUserId,
	SharedDepartNo,
	case when UserofDepart = 'user' then U.Name else D.Name end Name
	,UserofDepart,RegUserNo,RegDate 
	FROM BSLG_SpAuthInfo B
	LEFT JOIN Organization_Users U ON U.UserID = B.SharedUserId and B.UserofDepart = 'user'
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.SharedDepartNo
	where B.UserId = bslg_spauthlist.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
