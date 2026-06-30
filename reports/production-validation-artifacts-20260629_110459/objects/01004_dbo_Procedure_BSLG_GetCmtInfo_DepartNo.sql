-- ─── PROCEDURE→FUNCTION: bslg_getcmtinfo_departno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getcmtinfo_departno(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getcmtinfo_departno(
    IN langindex character varying,
    IN orgcd character varying,
    IN startdate character varying,
    IN enddate character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	RETURN QUERY
	select ID
		, Content
		, TargetID
		, WriterID
		, RegDate
		, Status 
		, U.Name as UserName
		, WriterDate 
		, D.Name as OrgNm
		, P.Name as PosNm
	from BSLG_Comment C
	INNER JOIN Organization_Users U on C.WriterID = U.UserID
	INNER JOIN Organization_BelongToDepartment B on B.UserNo = U.UserNo and B.IsDefault = TRUE
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE C.Status = Flag AND C.orgcd = bslg_getcmtinfo_departno.orgcd
	AND ( RegDate >= bslg_getcmtinfo_departno.startdate AND RegDate <= bslg_getcmtinfo_departno.enddate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
