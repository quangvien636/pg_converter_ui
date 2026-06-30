-- ─── FUNCTION: workingtime_reportdetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reportdetail(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtime_reportdetail(
    to timestamp without time zone
) RETURNS TABLE(
    userno text,
    name text,
    name_en text,
    nocheckin text,
    nocheckout text,
    latecount text,
    editcount text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    allstaff smallint;
    editcount smallint;
    latecount smallint;
    nocheckin smallint;
    nocheckout smallint;
    checkin smallint;
    checkout smallint;
    totalday smallint;
    checkintimetext character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


	IF(to>NOW())
		Set to = NOW()
	









	-- Tong so ngay giua from va to
	SELECT TotalDay = (to::date - from::date)+1


	-- Tong so nhan vien
	SELECT AllStaff = count(*) from Organization_Users Where Enabled = TRUE
	

	--======================================================================================
	-- Tong so check-in trong thoi gian [from -> to]: tinh lun ngay to
	--======================================================================================
	If(OBJECT_ID('tempdb..#EmployeeCheckInTable') Is Not Null)
	Begin
		Drop Table #EmployeeCheckInTable
	End
	RETURN QUERY
	SELECT RegUserNo, count(*) AS "CheckInCount" INTO #EmployeeCheckInTable FROM (
		SELECT RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  on TimeType=1 and t.WorkingNo=v.WorkingNo 
			and CONVERT(datetime2, CheckDateTimeOffset, 1) between from and DATEADD(ms, 86399997, to) 
		group by RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120)
	) as EmployeeCheckIn
	Group by RegUserNo

	RETURN QUERY
	SELECT * FROM #EmployeeCheckInTable


	--======================================================================================
	-- Tong so check-out trong thoi gian [from -> to]: tinh lun ngay to
	--======================================================================================
	If(OBJECT_ID('tempdb..#EmployeeCheckOutTable') Is Not Null)
	Begin
		Drop Table #EmployeeCheckOutTable
	End
	RETURN QUERY
	SELECT RegUserNo, count(*) AS "CheckOutCount" INTO #EmployeeCheckOutTable FROM (
		SELECT RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  on TimeType=3 and t.WorkingNo=v.WorkingNo 
			and CONVERT(datetime2, CheckDateTimeOffset, 1) between from and DATEADD(ms, 86399997, to) 
		group by RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120)
	) as EmployeeCheckOut
	Group by RegUserNo

	RETURN QUERY
	SELECT * FROM #EmployeeCheckOutTable


	--======================================================================================
	-- Tong so lan edit
	--======================================================================================
	If(OBJECT_ID('tempdb..#EmployeeEditTable') Is Not Null)
	Begin
		Drop Table #EmployeeEditTable
	End
	RETURN QUERY
	SELECT RegUserNo, count(*) AS "EditCount" INTO #EmployeeEditTable FROM (
		SELECT RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  on Provider=999 and t.WorkingNo=v.WorkingNo 
			and CONVERT(datetime2, CheckDateTimeOffset, 1) between from and DATEADD(ms, 86399997, to) 
		group by RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120)
	) AS EmployeeEdit
	Group by RegUserNo

	RETURN QUERY
	SELECT * FROM #EmployeeEditTable

	--======================================================================================
	-- Tong so lan di tre
	--======================================================================================

			,CheckInTime time
	SET CheckInTimeText = (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 1)+'00'
	SET CheckInTime = LEFT(CheckInTimeText,2)+':' || SUBSTRING(CheckInTimeText,3,2)+':' || RIGHT(CheckInTimeText,2)


	If(OBJECT_ID('tempdb..#EmployeeLateTable') Is Not Null)
	Begin
		Drop Table #EmployeeLateTable
	End
	RETURN QUERY
	SELECT RegUserNo, count(*) AS "LateCount" INTO #EmployeeLateTable FROM (
		SELECT RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t inner join  public."WorkingTime_Times_v2" v  on TimeType=1 and t.WorkingNo=v.WorkingNo 
		and CONVERT(datetime2, CheckDateTimeOffset, 1) between from and DATEADD(ms, 86399997, to)
		and CONVERT (TIME, CheckDateTimeOffset) > CONVERT (TIME, CheckInTime)
		Group by RegUserNo, CONVERT(varchar(10),CheckDateTimeOffset,120)
	) as EmployeeLate
	Group by RegUserNo

	RETURN QUERY
	SELECT * FROM #EmployeeLateTable

	RETURN QUERY
	SELECT UserNo, Name, Name_EN
	, COALESCE((TotalDay-i.CheckInCount), 0) AS "NoCheckIn"
	, COALESCE((TotalDay-o.CheckOutCount), 0) AS "NoCheckOut"
	, COALESCE(l.LateCount, 0) AS "LateCount"
	, COALESCE(e.EditCount, 0) AS "EditCount"
	FROM Organization_Users	
	LEFT OUTER JOIN #EmployeeCheckInTable i ON i.RegUserNo=UserNo
	LEFT OUTER JOIN #EmployeeCheckOutTable o ON o.RegUserNo=UserNo
	LEFT OUTER JOIN #EmployeeLateTable l ON l.RegUserNo=UserNo
	LEFT OUTER JOIN #EmployeeEditTable e ON e.RegUserNo=UserNo
	Where Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
