-- ─── PROCEDURE→FUNCTION: center_getcompanylicenceinformationlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getcompanylicenceinformationlist(integer, integer);
CREATE OR REPLACE FUNCTION public.center_getcompanylicenceinformationlist(
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

	




	TotalItemCount := (SELECT COUNT(*) FROM Center_CompanyLicenceInformation;
	join Organization_Users
	on Center_CompanyLicenceInformation.UserNo = Organization_Users.UserNo)
	
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := center_getcompanylicenceinformationlist.currentpageindex * CountPerPage;
	RETURN QUERY
	SELECT 
	*  FROM (
	SELECT 
	ROW_NUMBER() OVER (ORDER BY CompanyLicenceInformationDate desc) AS ROWNUM,	
	Organization_Users.Name as UserName
	,CompanyLicenceInformationNo
	,Center_CompanyLicenceInformation.UserNo
	,LicenceKey
	,Center_CompanyLicenceInformation.Name
	,Version
	,DB
	,UserCnt
	,CompanyLicenceInformationDate
	FROM Center_CompanyLicenceInformation
	join Organization_Users
	on Center_CompanyLicenceInformation.UserNo = Organization_Users.UserNo
	) V
	WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalAccessCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
