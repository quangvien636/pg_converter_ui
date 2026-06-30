-- ─── FUNCTION: center_getlicencelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getlicencelist(integer, integer);
CREATE OR REPLACE FUNCTION public.center_getlicencelist(
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    rownum text,
    username text,
    companieslicenceno text,
    userno text,
    licencekey text,
    name text,
    version text,
    db text,
    usercnt text,
    companieslicencedate text,
    enabled text
)
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN

	




	SET TotalItemCount = (SELECT COUNT(*) FROM Center_CompaniesLicence
	join Organization_Users
	on Center_CompaniesLicence.UserNo = Organization_Users.UserNo)
	
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = center_getlicencelist.currentpageindex * CountPerPage
	
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
