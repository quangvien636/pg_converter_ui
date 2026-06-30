-- ─── PROCEDURE→FUNCTION: sourcecontrol_getcompanies ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.sourcecontrol_getcompanies();
CREATE OR REPLACE FUNCTION public.sourcecontrol_getcompanies(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH TotalCount AS ( SELECT COUNT(*) AS Total FROM SourceControl_Company WHERE DISABLE=0)
	RETURN QUERY
	SELECT SC.Id,SC.Name AS CompanyName,SC.Code AS CompanyCode,SC.Website,SC.IpAddress,(SELECT /* /* TOP 1 */ */Total FROM TotalCount) AS TotalCount
	FROM SourceControl_Company SC
	 WHERE SC.DISABLE=0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
