-- ─── FUNCTION: center_getaccesslog ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getaccesslog(character varying, character varying, timestamp without time zone, timestamp without time zone, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.center_getaccesslog(
    username character varying,
    clientip character varying,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    ipexclusion integer,
    applicationno integer,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    rownum text,
    logno text,
    userno text,
    username text,
    clientip text,
    accessdate text,
    applicationno text
)
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN

	




	IF IPExclusion = 0
	BEGIN
		SET TotalItemCount = (SELECT COUNT(*) FROM Center_AccessLogs
		join Organization_Users
		on Center_AccessLogs.UserNo = Organization_Users.UserNo
		WHERE Organization_Users.Name ILIKE '%' || UserName || '%'
		and Center_AccessLogs.ClientIP ILIKE '%' || ClientIP || '%'
		and (case when ApplicationNo = 0 then 0
				else Center_AccessLogs.ApplicationNo end )
				= center_getaccesslog.applicationno
		and convert(varchar(10), Center_AccessLogs.AccessDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120))
	END
	ELSE
	BEGIN
		SET TotalItemCount = (SELECT COUNT(*) FROM Center_AccessLogs
		join Organization_Users
		on Center_AccessLogs.UserNo = Organization_Users.UserNo
		WHERE Organization_Users.Name ILIKE '%' || UserName || '%'
		and Center_AccessLogs.ClientIP not ILIKE '%' || ClientIP || '%'
		and (case when ApplicationNo = 0 then 0
				else Center_AccessLogs.ApplicationNo end )
				= center_getaccesslog.applicationno
		and convert(varchar(10), Center_AccessLogs.AccessDate, 120) between convert(varchar(10), StartDate, 120) and convert(varchar(10), EndDate, 120))
	END

	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = center_getaccesslog.currentpageindex * CountPerPage
	
	IF IPExclusion = 0
	BEGIN
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
	END
	ELSE
	BEGIN
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
	END

	RETURN QUERY
	SELECT TotalItemCount AS TotalAccessCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
