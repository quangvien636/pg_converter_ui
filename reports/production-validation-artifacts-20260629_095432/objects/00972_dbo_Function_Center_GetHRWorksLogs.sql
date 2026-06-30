-- ─── FUNCTION: center_gethrworkslogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_gethrworkslogs(timestamp without time zone, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.center_gethrworkslogs(
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    rownum text,
    hrworksno text,
    hrworksdate text,
    usersinsert text,
    usersupdate text,
    departmentsinsert text,
    departmentsupdate text,
    dutiesinsert text,
    dutiesupdate text,
    positionsinsert text,
    positionsupdate text
)
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN

	




	SET TotalItemCount = (SELECT COUNT(*) FROM Center_HRWorksLogs
	WHERE convert(varchar(10), HRWorksDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120))
	
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = center_gethrworkslogs.currentpageindex * CountPerPage
	
	RETURN QUERY
	SELECT 
	ROWNUM
	HRWorksNo
	,HRWorksDate
	,UsersInsert
	,UsersUpdate
	,DepartmentsInsert
	,DepartmentsUpdate
	,DutiesInsert
	,DutiesUpdate
	,PositionsInsert
	,PositionsUpdate  FROM (
	SELECT 
	ROW_NUMBER() OVER (ORDER BY HRWorksDate desc) AS ROWNUM,	
	HRWorksNo
	,HRWorksDate
	,UsersInsert
	,UsersUpdate
	,DepartmentsInsert
	,DepartmentsUpdate
	,DutiesInsert
	,DutiesUpdate
	,PositionsInsert
	,PositionsUpdate FROM Center_HRWorksLogs WHERE  convert(varchar(10), HRWorksDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120)
	) V
	WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalAccessCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
