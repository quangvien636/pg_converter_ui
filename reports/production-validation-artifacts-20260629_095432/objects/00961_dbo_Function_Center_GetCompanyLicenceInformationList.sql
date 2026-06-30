-- ─── FUNCTION: center_getcompanylicenceinformationlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getcompanylicenceinformationlist(integer, integer);
CREATE OR REPLACE FUNCTION public.center_getcompanylicenceinformationlist(
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    rownum text,
    username text,
    companylicenceinformationno text,
    userno text,
    licencekey text,
    name text,
    version text,
    db text,
    usercnt text,
    companylicenceinformationdate text
)
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN

	




	SET TotalItemCount = (SELECT COUNT(*) FROM Center_CompanyLicenceInformation
	join Organization_Users
	on Center_CompanyLicenceInformation.UserNo = Organization_Users.UserNo)
	
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = center_getcompanylicenceinformationlist.currentpageindex * CountPerPage
	
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
