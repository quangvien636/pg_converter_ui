-- ─── FUNCTION: workingtime_reports_export ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reports_export(integer, character varying, character varying, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_reports_export(
    userno integer,
    fromdate character varying,
    todate character varying,
    departno integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS void
AS $function$
DECLARE
    workingtime_cursor cursor;
BEGIN


	
			SELECT 
			    ROW_NUMBER() OVER(ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC, DT.SortNo ASC, U.Name ASC) AS rowNum,
				B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN,
				D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN
				,D.SortNo AS DepartSortNo,
				P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo
				,COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo
				,COALESCE(G.TimeIn,ST1.SettingValue) TimeIn
				,(cast(SUBSTRING(ST3.SettingValue,1,3) as int)*60+cast(SUBSTRING(ST3.SettingValue,5,2) as int))/ 60 TimeOffset
				into #ListOfUsers
			FROM Organization_BelongToDepartment B 
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno	where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 7) ST3 ON 1 = 1
			LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_reports_export.departno
			WHERE (DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(DepartNo, 0)))
			AND B.IsDefault = TRUE
			AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_reports_export.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_reports_export.p_groupno))
			AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
			AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
			AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')
			ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC, DT.SortNo ASC, U.Name ASC
	---------------------------- End Filter user hide when no permission-------------------------

	IF NOW() < CONVERT(DATETIME, ToDate, 1) SET ToDate = CONVERT(VARCHAR, NOW(), 112)


		UserID				VARCHAR(100),
		Name				NVARCHAR(100),
		Name_EN			NVARCHAR(100),
		DepartName			NVARCHAR(100),
		DepartName_EN		NVARCHAR(100),
		PositionName		NVARCHAR(100),
		PositionName_EN	NVARCHAR(100),
		DutyName			NVARCHAR(100),
		DutyName_EN		NVARCHAR(100),
		TotalNoCheckIn		INT = 0,
		TotalNoCheckOut	INT	= 0,
		TotalLate			INT = 0,
		TotalEdit			INT = 0,
		CheckInTimeText	VARCHAR(10),
		CheckInTime		TIME,
		--OffSetCompany		VARCHAR(6),
		TotalDays			INT = (ToDate::date - FromDate::date) + 1,
		TimeIn char(4),
		TimeOffset float = 0,
		TotalTime int = 0,
		TotalTime2 int = 0,
		TotalVacation int = 0,
		TotalDayOff int = 0


		UserNo				INT,
		UserID				VARCHAR(100),
		Name				NVARCHAR(100),
		Name_EN				NVARCHAR(100),
		DepartName			NVARCHAR(100),
		DepartName_EN		NVARCHAR(100),
		PositionName		NVARCHAR(100),
		PositionName_EN		NVARCHAR(100),
		DutyName			NVARCHAR(100),
		DutyName_EN			NVARCHAR(100),
		TotalNoCheckIn		INT,
		TotalNoCheckOut		INT,
		TotalLate			INT,
		TotalEdit			INT,
		TimeWork int,
		DayOff int,
		TimeWork2 int,
		Vacation int
	)


		WorkingNo			INT,
		WorkingDay			INT,
		CheckTime		DATETIMEOFFSET,
		TimeType			INT,
		Provider			INT,
		Status			BIT,
		StarWorking char(4),
		TimeOffset float
	)

	--------------------------------------------------------------------------------------------------------------------

	--SET OffSetCompany = (SELECT SettingValue FROM WorkingTime_Settings WHERE SettingNo = 7)

	SET WorkingTime_Cursor = CURSOR FAST_FORWARD
		FOR SELECT UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN,TimeIn, TimeOffset FROM #ListOfUsers  ORDER BY rowNum
	OPEN WorkingTime_Cursor
	FETCH NEXT FROM WorkingTime_Cursor
	INTO _UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN,TimeIn, TimeOffset
	WHILE @FETCH_STATUS = 0 BEGIN

		DELETE FROM ReturnWorkingTime;
		INSERT INTO ReturnWorkingTime(WorkingNo,WorkingDay, CheckTime, TimeType, Provider, Status, StarWorking,TimeOffset)
		SELECT wt.WorkingNo, wt2.WorkingDayOfCompany, wt2.CheckDateTimeOffset, wt.TimeType, wt.Provider, COALESCE(wr.Status, 1) AS Status
			   ,COALESCE(WT.StarWorking,TimeIn) ,COALESCE(WT.TimeOffset,TimeOffset)
		FROM WorkingTime_Times wt 
		INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
		LEFT JOIN WorkingTime_RequestCorrectionTime wr ON wt.WorkingNo = wr.WorkingNo 
		WHERE wt2.WorkingDayOfCompany BETWEEN FromDate AND ToDate AND wt.UserNo = _UserNo AND wt.TimeType IN (1, 3, 8, 6)
		and COALESCE(wt.status,0) != 1
		ORDER BY wt2.CheckDateTimeOffset ASC

		SET TotalNoCheckIn = 0
		SET TotalNoCheckOut = 0
		SET TotalLate = 0
		SET TotalEdit = 0
		
		select TotalTime2 =  sum(case when (wc.TimeType = -2 or wc.TimeType = -3) then 4 else 8 end ), TotalVacation =  Count(*)  from WorkingTime_Times wc where wc.UserNo = _UserNo and  wc.TimeType < 0  and wc.WorkingDayC BETWEEN FromDate AND ToDate
		select TotalTime =  sum(c.TimeWork)  from WorkingTime_Calculater c where c.UserNo = _UserNo and  c.status = 1 and c.WorkingDay BETWEEN FromDate AND ToDate
		select TotalDayOff =  (TotalDays  - COUNT(*))  from WorkingTime_Calculater c where c.UserNo = _UserNo  and c.WorkingDay BETWEEN FromDate AND ToDate


		SELECT TotalNoCheckIn = (TotalDays - COUNT(*)) FROM (SELECT _UserNo AS UserNo FROM ReturnWorkingTime WHERE Status = 1 AND (TimeType = 1 OR TimeType = 8) GROUP BY WorkingDay) AS CheckIn

		SELECT TotalNoCheckOut = (TotalDays - COUNT(*)) FROM (SELECT _UserNo AS UserNo FROM ReturnWorkingTime WHERE Status = 1 AND (TimeType = 3 OR TimeType = 6) GROUP BY WorkingDay) AS CheckOut
		BEGIN
		
			WITH CTE AS (
				SELECT *, RN = ROW_NUMBER() OVER (PARTITION BY WorkingDay ORDER BY CheckTime)
				FROM ReturnWorkingTime 
				WHERE Status = 1 AND (TimeType = 1 OR TimeType = 8 )
			)
		
			SELECT TotalLate = COUNT(*) FROM CTE 
			WHERE DATEPART(Minute, CheckTime)+ DATEPART(Hour, CheckTime)*60 > 
				  (cast(LEFT(StarWorking,2) as int)*60+ cast(SUBSTRING(StarWorking,3,2) as int))
				  AND RN = 1	
								

		END
		SELECT TotalEdit = COUNT(*) FROM (SELECT _UserNo AS UserNo FROM ReturnWorkingTime WHERE Provider = 999 GROUP BY WorkingDay) AS Edit

		IF (TotalNoCheckIn < 0) SET TotalNoCheckIn = 0
		IF (TotalNoCheckOut < 0) SET TotalNoCheckOut = 0
		IF (TotalLate < 0) SET TotalLate = 0
		IF (TotalEdit < 0) SET TotalEdit = 0

		INSERT INTO ListOfReport (UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit, TimeWork, DayOff, TimeWork2, Vacation)
		VALUES (_UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit, TotalTime, TotalDayOff, COALESCE(TotalTime,0) + (COALESCE(TotalTime2,0)*60), TotalVacation) 

		FETCH NEXT FROM WorkingTime_Cursor
			INTO _UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN,TimeIn, TimeOffset
		END
	CLOSE WorkingTime_Cursor
	DEALLOCATE WorkingTime_Cursor
		SELECT UserNo
			   , Name, Name_EN
			   , UserID, DepartName
			   , DepartName_EN
			   , PositionName
			   , PositionName_EN
			   , DutyName, DutyName_EN
			   ,CAST(TimeWork2/60 AS VARCHAR) + ':' || case when TimeWork2%60 <10 then '0' || CAST(TimeWork2%60 AS VARCHAR) else  CAST(TimeWork2%60 AS VARCHAR) end TimeWork2
			   ,CAST(TimeWork/60 AS VARCHAR) + ':' || case when TimeWork%60 <10 then '0' || CAST(TimeWork%60 AS VARCHAR) else  CAST(TimeWork%60 AS VARCHAR) end TimeWork
			   , TotalLate
			   , Vacation
			   , DayOff
			   , TotalNoCheckIn
			   , TotalNoCheckOut
			   , TotalEdit
		FROM ListOfReport;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
