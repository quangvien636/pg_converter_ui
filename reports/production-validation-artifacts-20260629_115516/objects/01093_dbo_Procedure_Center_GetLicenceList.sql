-- ─── PROCEDURE→FUNCTION: center_getlicencelist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getlicencelist(integer, integer);
CREATE OR REPLACE FUNCTION public.center_getlicencelist(
    IN countperpage integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	




	TotalItemCount := (SELECT COUNT(*) FROM Center_CompaniesLicence;
	join Organization_Users
	on Center_CompaniesLicence.UserNo = Organization_Users.UserNo)
	
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := center_getlicencelist.currentpageindex * CountPerPage;
	RETURN QUERY
	SELECT 
	*  FROM (
	SELECT 
	ROW_NUMBER() OVER (ORDER BY CompaniesLicenceDate desc) AS ROWNUM,	
	Organization_Users.Name as UserName
	,CompaniesLicenceNo
	,Center_CompaniesLicence.UserNo
	,LicenceKey
	,Center_CompaniesLicence.Name
	,Version
	,DB
	,UserCnt
	,CompaniesLicenceDate
	,Center_CompaniesLicence.Enabled
	FROM Center_CompaniesLicence
	join Organization_Users
	on Center_CompaniesLicence.UserNo = Organization_Users.UserNo
	) V
	WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalAccessCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
