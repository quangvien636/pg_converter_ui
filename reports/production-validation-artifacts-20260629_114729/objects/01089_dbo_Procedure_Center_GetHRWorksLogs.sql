-- ─── PROCEDURE→FUNCTION: center_gethrworkslogs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_gethrworkslogs(timestamp without time zone, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.center_gethrworkslogs(
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone,
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

	




	TotalItemCount := (SELECT COUNT(*) FROM Center_HRWorksLogs;
	WHERE convert(varchar(10), HRWorksDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120))
	
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := center_gethrworkslogs.currentpageindex * CountPerPage;
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
