-- ─── PROCEDURE→FUNCTION: bslg_spauthuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_spauthuserlist(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthuserlist(
    IN userid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	RETURN QUERY
	SELECT 
	B.SharedUserId  as Code,
	U.Name as Name
	, COALESCE(D.Name,'') as OrgNm
	, COALESCE(P.Name,'') as PosNm
	FROM BSLG_SpAuthInfo B
	LEFT JOIN Organization_Users U ON U.UserID = B.SharedUserId and B.UserofDepart = 'user'
	--and B.UserofDepart = 'depart'
	LEFT JOIN Organization_BelongToDepartment BE on BE.UserNo = U.UserNo and BE.IsDefault = TRUE
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.SharedDepartNo or D.DepartNo = BE.DepartNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = BE.PositionNo
	where UserofDepart = 'user'
	AND B.UserId = bslg_spauthuserlist.userid

	union

	RETURN QUERY
	SELECT 
	U.UserID as Code,
	U.Name as Name
	, COALESCE(D.Name,'') as OrgNm
	, COALESCE(P.Name,'') as PosNm
	FROM BSLG_SpAuthInfo B
	LEFT JOIN Organization_BelongToDepartment BE on BE.DepartNo = B.SharedDepartNo and BE.IsDefault = TRUE
	LEFT JOIN Organization_Users U ON U.UserNo = BE.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.SharedDepartNo or D.DepartNo = BE.DepartNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = BE.PositionNo
	where UserofDepart = 'depart'
	AND B.UserId = bslg_spauthuserlist.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
