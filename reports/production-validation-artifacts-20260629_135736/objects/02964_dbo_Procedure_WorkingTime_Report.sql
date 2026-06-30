-- ─── PROCEDURE→FUNCTION: workingtime_report ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.workingtime_report(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtime_report(
    IN to timestamp without time zone
) RETURNS SETOF record
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
		to := NOW();
	--======================================================================================
	-- Tong so ngay giua from va to
	--======================================================================================
	TotalDay := ((to::date - from::date)+1);
	--======================================================================================
	-- Tong so nhan vien
	--======================================================================================
	SELECT count(*) INTO allstaff from Organization_Users Where Enabled = TRUE
	

	--======================================================================================
	-- Tong so check-in trong thoi gian [from -> to]: tinh lun ngay to
	--======================================================================================
	SELECT count(*) INTO checkin FROM (

		SELECT RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  on TimeType=1 and t.WorkingNo=v.WorkingNo 
		and CONVERT(datetime, left(v.CheckDateTimeOffset,19), 120) between from and DATEADD(ms, 86399997, to) 
		group by RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120)

	) as CheckInTable

	--======================================================================================
	-- Tong so check-out trong thoi gian [from -> to]: tinh lun ngay to
	--======================================================================================
	SELECT count(*) INTO checkout FROM (

		SELECT RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  on TimeType=3 and t.WorkingNo=v.WorkingNo 
		and CONVERT(datetime, left(v.CheckDateTimeOffset,19), 120) between from and DATEADD(ms, 86399997, to)
		group by RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120)

	) as CheckOutTable

	--======================================================================================
	-- Tong so lan khong check-in
	--======================================================================================
	NoCheckIn := ((TotalDay*AllStaff - CheckIn));
	--======================================================================================
	-- Tong so lan khong check-out
	--======================================================================================
	NoCheckOut := ((TotalDay*AllStaff - CheckOut));
	--======================================================================================
	-- Tong so lan edit
	--======================================================================================
	SELECT count(*) INTO editcount FROM (

		SELECT RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  
			on Provider=999 and t.WorkingNo=v.WorkingNo 
			and CONVERT(datetime2, CheckDateTimeOffset, 1) between from and DATEADD(ms, 86399997, to)
		group by RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120)

	) AS Edit_Count


	--======================================================================================
	-- Tong so lan di tre
	--======================================================================================

			,CheckInTime time
	CheckInTimeText := (SELECT SettingValue FROM public."WorkingTime_Settings" where SettingNo = 1)+'00';
	CheckInTime := LEFT(CheckInTimeText,2)+':' || SUBSTRING(CheckInTimeText,3,2)+':' || RIGHT(CheckInTimeText,2);
	SELECT count(*) INTO latecount FROM (

		SELECT RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120) AS "RegDate" from public."WorkingTime_Times" t 
		inner join  public."WorkingTime_Times_v2" v  
			on TimeType=1 and t.WorkingNo=v.WorkingNo 
			and CONVERT(datetime2, CheckDateTimeOffset, 1) between from and DATEADD(ms, 86399997, to)
			and CONVERT (TIME, CheckDateTimeOffset) > CONVERT (TIME, CheckInTime)
			and v.WorkingNo in (--chon check-in dau tien trong ngay
								Select /* TOP 1 */ sv.WorkingNo From public."WorkingTime_Times_v2" sv 
								inner join public."WorkingTime_Times" st 
									on st.WorkingNo=sv.WorkingNo
									and st.TimeType=t.TimeType
									and st.RegUserNo=t.RegUserNo
									and CONVERT(varchar(10),sv.CheckDateTimeOffset,120) = CONVERT(varchar(10), v.CheckDateTimeOffset,120)
								order by sv.CheckDateTimeOffset asc )
		group by RegUserNo, CONVERT(varchar(10),v.CheckDateTimeOffset,120)

	) AS LateTable

	RETURN QUERY
	SELECT TotalDay AS "TotalDay", AllStaff AS "AllStaff", NoCheckIn AS "NoCheckIn", NoCheckOut AS "NoCheckOut", EditCount AS "EditCount", LateCount AS "LateCount";
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
