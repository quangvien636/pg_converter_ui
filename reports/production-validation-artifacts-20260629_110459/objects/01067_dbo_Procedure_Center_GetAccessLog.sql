-- ─── PROCEDURE→FUNCTION: center_getaccesslog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getaccesslog(character varying, character varying, timestamp without time zone, timestamp without time zone, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.center_getaccesslog(
    IN username character varying,
    IN clientip character varying,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone,
    IN ipexclusion integer,
    IN applicationno integer,
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

	




	IF IPExclusion = 0 THEN
		TotalItemCount := (SELECT COUNT(*) FROM Center_AccessLogs;
		join Organization_Users
		on Center_AccessLogs.UserNo = Organization_Users.UserNo
		WHERE Organization_Users.Name ILIKE '%' || UserName || '%'
		and Center_AccessLogs.ClientIP ILIKE '%' || ClientIP || '%'
		and (case when ApplicationNo = 0 then 0
				else Center_AccessLogs.ApplicationNo end )
				= center_getaccesslog.applicationno
		and convert(varchar(10), Center_AccessLogs.AccessDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120))
	END IF;
	ELSE
		TotalItemCount := (SELECT COUNT(*) FROM Center_AccessLogs;
		join Organization_Users
		on Center_AccessLogs.UserNo = Organization_Users.UserNo
		WHERE Organization_Users.Name ILIKE '%' || UserName || '%'
		and Center_AccessLogs.ClientIP not ILIKE '%' || ClientIP || '%'
		and (case when ApplicationNo = 0 then 0
				else Center_AccessLogs.ApplicationNo end )
				= center_getaccesslog.applicationno
		and convert(varchar(10), Center_AccessLogs.AccessDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120))
	END IF;

	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := center_getaccesslog.currentpageindex * CountPerPage;
	IF IPExclusion = 0 THEN
		RETURN QUERY
		SELECT 
		ROWNUM
		,LogNo
		,UserNo
		,UserName
		,ClientIP
		,AccessDate
		,ApplicationNo  FROM (
		SELECT 
		ROW_NUMBER() OVER (ORDER BY AccessDate desc) AS ROWNUM,	
		LogNo
		,Organization_Users.UserNo as UserNo
		,Organization_Users.Name as UserName
		,ClientIP
		,AccessDate
		,ApplicationNo FROM Center_AccessLogs
		join Organization_Users
		on Center_AccessLogs.UserNo = Organization_Users.UserNo
		WHERE Organization_Users.Name ILIKE '%' || UserName || '%'
		and Center_AccessLogs.ClientIP ILIKE '%' || ClientIP || '%'
		and (case when ApplicationNo = 0 then 0
				else Center_AccessLogs.ApplicationNo end )
				= center_getaccesslog.applicationno
		and convert(varchar(10), Center_AccessLogs.AccessDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120)
		) V
		WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	END IF;
	ELSE
		RETURN QUERY
		SELECT 
		ROWNUM
		,LogNo
		,UserNo
		,UserName
		,ClientIP
		,AccessDate
		,ApplicationNo  FROM (
		SELECT 
		ROW_NUMBER() OVER (ORDER BY AccessDate desc) AS ROWNUM,	
		LogNo
		,Organization_Users.UserNo as UserNo
		,Organization_Users.Name as UserName
		,ClientIP
		,AccessDate
		,ApplicationNo FROM Center_AccessLogs
		join Organization_Users
		on Center_AccessLogs.UserNo = Organization_Users.UserNo
		WHERE Organization_Users.Name ILIKE '%' || UserName || '%'
		and Center_AccessLogs.ClientIP not ILIKE '%' || ClientIP || '%'
		and (case when ApplicationNo = 0 then 0
				else Center_AccessLogs.ApplicationNo end )
				= center_getaccesslog.applicationno
		and convert(varchar(10), Center_AccessLogs.AccessDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120)
		) V
		WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	END IF;

	RETURN QUERY
	SELECT TotalItemCount AS TotalAccessCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
