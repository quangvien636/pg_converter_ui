-- ─── FUNCTION: workingtime_allemployeelate ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_allemployeelate(integer, timestamp without time zone, timestamp without time zone, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_allemployeelate(
    userno integer,
    fromdate timestamp without time zone,
    todate timestamp without time zone,
    timeoffset character varying,
    departno integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    permissiontype integer DEFAULT 3
) RETURNS TABLE(
    rn text,
    workingdayofcompany text,
    userno text,
    workingno text,
    checkdatetimeoffset text,
    latitude text,
    longitude text,
    ipserver text,
    distance text,
    latcompany text,
    lngcompany text,
    timetype text,
    provider text,
    status text,
    beaconinfo text,
    starworking text,
    timeoffset text,
    col18 text,
    checktime text
)
AS $function$
BEGIN


	WITH ListOfUsers AS(
			SELECT 

				B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
				D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
				P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
				COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo,
				U.BirthDate
				,COALESCE(G.TimeIn,ST1.SettingValue) TimeIn
				,COALESCE(G.TimeOut,ST2.SettingValue) TimeOut
			FROM Organization_BelongToDepartment B 
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE AND U.UserID <> '' 
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 2) ST2 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 7) ST3 ON 1 = 1
			WHERE (DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(DepartNo, 0)))
			AND B.IsDefault = TRUE
			AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_allemployeelate.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_allemployeelate.p_groupno))

	)
	---------------------------- End Filter user hide when no permission-------------------------


	RETURN QUERY
	SELECT  CONVERT (DATE,convert(char(8),T.WorkingDayOfCompany)) AS DateCheck, 
			U.UserNo, 
			U.Name AS "UserName", 
			U.Name_EN AS "UserNameEN",
			U.PositionName AS "Position",
			U.PositionName_EN AS "PositionEN",
			U.DepartName AS "Department",
			U.DepartName_EN AS "DepartmentEN",
			T.WorkingNo,
			T.CheckDateTimeOffset AS "TimeCheckIn",
			T.Latitude,
			T.Longitude AS "Longtitude",
			T.IpServer,
			T.Distance,
			T.LatCompany,
			T.LngCompany,
			 t.CheckTime - (cast(LEFT(COALESCE(StarWorking,u.TimeIn),2) as int)*60+ cast(SUBSTRING(COALESCE(StarWorking,u.TimeIn),3,2) as int)) AS "TimeLate",
			--public."UF_CalTimeLateIgnoreTimezone"(CheckDateTimeOffset) AS "TimeLate",
			u.PositionSortNo AS "SortNo",
			T.BeaconInfo,
			T.Provider,
			T.CheckTime,
			U.TimeIn,
			U.TimeOut
	FROM ListOfUsers U INNER JOIN 
	(
		SELECT ROW_NUMBER()OVER(PARTITION BY wt.WorkingDayC,wt.UserNo,wt.TimeType ORDER BY wt.CheckTimeFull) AS RN
				,wt.WorkingDayC AS WorkingDayOfCompany
				,wt.UserNo
				,wt.WorkingNo
				,wt.CheckTimeFull as CheckDateTimeOffset
				,wt.Latitude
				,wt.Longitude
				,wt.IpServer
				,wt.Distance
				,wt.LatCompany
				,wt.LngCompany
				,wt.TimeType
				,wt.Provider
				,1 AS Status
				,wt.BeaconInfo
				,wt.StarWorking
				,wt.TimeOffset
				,wt.CheckTime CheckTime2
				,wt.CheckTime
				FROM WorkingTime_Times wt  
				WHERE wt.WorkingDayC BETWEEN CAST(CONVERT(VARCHAR(8),FromDate,112) AS INT) AND CAST(CONVERT(VARCHAR(8),ToDate,112) AS INT)
					AND wt.TimeType= 1
	) AS T ON U.UserNo = T.UserNo 
	WHERE CheckTime > 
		  (cast(LEFT(COALESCE(StarWorking,u.TimeIn),2) as int)*60+ cast(SUBSTRING(COALESCE(StarWorking,u.TimeIn),3,2) as int))
		 AND T.RN = 1
		 AND T.Status = 1
	 ORDER BY DateCheck;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
