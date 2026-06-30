-- ─── PROCEDURE→FUNCTION: workingtime_allemployeenocheckout ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.workingtime_allemployeenocheckout(timestamp without time zone, timestamp without time zone, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_allemployeenocheckout(
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_depart integer DEFAULT 0,
    IN p_groupno integer DEFAULT 0,
    IN p_uid character varying DEFAULT '',
    IN p_uname character varying DEFAULT '',
    IN p_unameen character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
    datecheck date;
    listnocheckout table(
		datecheck date
		, userno int
		, username nvarchar(100);
    workingtime_cursor cursor;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	,
		Name				NVARCHAR(100),
		Name_EN				NVARCHAR(100),
		MailAddress			NVARCHAR(200),
		CellPhone			VARCHAR(100),
		CompanyPhone		VARCHAR(100),
		UserPhoto			BIT,
		Photo				NVARCHAR(500),
		Enabled			BIT,
		DepartNo			INT,
		DepartName			NVARCHAR(100),
		DepartName_EN		NVARCHAR(100),
		DepartSortNo		INT,
		PositionNo			INT,
		PositionName		NVARCHAR(100),
		PositionName_EN		NVARCHAR(100),
		PositionSortNo		INT,
		DutyNo				INT,
		DutyName			NVARCHAR(100),
		DutyName_EN			NVARCHAR(100),
		DutySortNo			INT
	);
	INSERT INTO ListOfUsers
	RETURN QUERY
	SELECT 

		B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
		COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo
	FROM Organization_BelongToDepartment B 
	INNER JOIN (SELECT u1.* FROM Organization_Users U1
		LEFT JOIN WorkingTime_AllowDevices A
		ON U1.userno = a.userno
		where COALESCE(ContentAllow, 'true') ILIKE '%true%' and U1.Enabled = TRUE AND U1.IsVirtual = FALSE) U  ON U.UserNo = B.UserNo 
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
	LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
	WHERE (p_Depart = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_Depart, 0)))
	AND B.IsDefault = TRUE
	AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_allemployeenocheckout.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_allemployeenocheckout.p_groupno))
	AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
	AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
	AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')
	---------------------------- End Filter user hide when no permission-------------------------

			, _UserNo INT
			, UserName NVARCHAR(100)
			, UserNameEN NVARCHAR(100)
			, Position NVARCHAR(100)
			, PositionEN NVARCHAR(100)
			, Department NVARCHAR(100)
			, DepartmentEN NVARCHAR(100)
			, PositionSortNo INT
			, PositionNo INT
			, DutyNo INT
			, DutySortNo INT
			, CountCheckOut INT = 0
			, CountCheckIn INT = 0
			, StatusCheckOut INT = 0
			, StatusCheckIn INT = 0

		, UserNameEN NVARCHAR(100)
		, Position NVARCHAR(100)
		, PositionEN NVARCHAR(100)
		, Department NVARCHAR(100)
		, DepartmentEN NVARCHAR(100)
		, PositionSortNo INT
		, PositionNo INT
		, DutyNo INT
		, DutySortNo INT
		, TimeCheckIn DATETIMEOFFSET
		, Latitude FLOAT
		, Longtitude FLOAT
		, IpServer NVARCHAR(250)
		, Distance NVARCHAR(200)
		, TimeLate INT
		, SortNo INT
		, LatCompany FLOAT
		, LngCompany FLOAT
		, BeaconInfo NVARCHAR(500)
		, Provider INT
	)


	,
		Distance varchar(250),
		LatCompany float,
		LngCompany float,
		Status BIT,
		RN INT,
		BeaconInfo nvarchar(500)
	)
	

	WorkingTime_Cursor := CURSOR FAST_FORWARD;
		FOR
		WITH nums AS(SELECT 0 AS number UNION ALL  SELECT number + 1 AS number FROM nums  WHERE nums.number <=40)   
			RETURN QUERY
			SELECT   CONVERT(date,DATEADD(DAY,number,p_From)) as DateCheck
					, U.UserNo
					, U.Name AS "UserName"
					, U.Name_EN AS "UserNameEN"
					, U.PositionName AS "Position"
					, U.PositionName_EN AS "PositionEN"
					, U.DepartName AS "Department"
					, U.DepartName_EN AS "DepartmentEN"
					, U.PositionSortNo
					, U.PositionNo
					, U.DutyNo
					, U.DutySortNo
				FROM nums, ListOfUsers U
				WHERE  DATEADD(DAY,number,p_From) <= workingtime_allemployeenocheckout.p_to AND DATEADD(DAY,number,p_From) <= NOW() --AND type = 'P' 
			ORDER BY DateCheck, PositionSortNo, UserName
	OPEN WorkingTime_Cursor
	FETCH NEXT FROM WorkingTime_Cursor
	INTO DateCheck,_UserNo, UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo
	WHILE @FETCH_STATUS = 0
		BEGIN;
			DELETE FROM ReturnWorkingTime;
			INSERT INTO ReturnWorkingTime(UserNo,WorkingDay,CheckTime,TimeType,Provider,Latitude,Longtitude,IpServer,Distance,LatCompany,LngCompany,Status,RN,BeaconInfo)
				RETURN QUERY
				SELECT	wt.UserNo
					, wt2.WorkingDayOfCompany
					, wt2.CheckDateTimeOffset
					, wt.TimeType
					, wt.Provider
					, wt.Latitude
					, wt.Longitude
					, wt.IpServer
					, wt.Distance
					, wt.LatCompany
					, wt.LngCompany
					, COALESCE(wr.Status, 1) AS Status
					, RN = ROW_NUMBER()OVER(PARTITION BY WorkingDayOfCompany,TimeType ORDER BY CheckDateTimeOffset)
					, wt.BeaconInfo
					FROM WorkingTime_Times wt 
						INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
						LEFT JOIN WorkingTime_RequestCorrectionTime wr ON wt.WorkingNo = wr.WorkingNo 
					WHERE COALESCE(WorkingDayC, WT2.WorkingDayOfCompany) = CAST(CONVERT(VARCHAR(8),DateCheck,112) AS INT)
						AND wt.TimeType IN (1,3,8,6)
						AND wt.UserNo = _UserNo
					ORDER BY wt2.CheckDateTimeOffset
				
				CountCheckOut := 0;
				CountCheckIn := 0;
				StatusCheckOut := 0;
				StatusCheckIn := 0;
				SELECT COUNT(*) INTO countcheckout FROM ReturnWorkingTime WHERE TimeType IN (3,6)
				SELECT COUNT(*) INTO countcheckin FROM ReturnWorkingTime WHERE TimeType IN (1,8)

				IF CountCheckOut = 0 AND CountCheckIn = 0 THEN;
					INSERT INTO ListNoCheckOut(DateCheck,UserNo,UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													TimeCheckIn,Latitude,Longtitude,IpServer,Distance,TimeLate,SortNo,LatCompany,LngCompany,BeaconInfo,Provider)
										VALUES(DateCheck,_UserNo, UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
				END IF;
				ELSIF CountCheckOut = 0 AND CountCheckIn > 0 THEN;
					INSERT INTO ListNoCheckOut(DateCheck,UserNo,UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													TimeCheckIn,Latitude,Longtitude,IpServer,Distance,TimeLate,SortNo,LatCompany,LngCompany,BeaconInfo,Provider)
										RETURN QUERY
										SELECT /* TOP 1 */ DateCheck,_UserNo, UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													CheckTime,Latitude,Longtitude,IpServer,Distance,0,0,LatCompany,LngCompany,BeaconInfo,Provider
													FROM ReturnWorkingTime
				END IF;
				ELSIF CountCheckOut > 0 THEN
					
					RETURN QUERY
					SELECT /* TOP 1 */ StatusCheckOut = Status FROM ReturnWorkingTime WHERE TimeType IN (3,6)
					RETURN QUERY
					SELECT /* TOP 1 */ StatusCheckIn = Status FROM ReturnWorkingTime WHERE TimeType IN (1,8)

					IF StatusCheckOut = 0 AND StatusCheckIn = 0 THEN;
						INSERT INTO ListNoCheckOut(DateCheck,UserNo,UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													TimeCheckIn,Latitude,Longtitude,IpServer,Distance,TimeLate,SortNo,LatCompany,LngCompany,BeaconInfo,Provider)
										VALUES(DateCheck,_UserNo, UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
					END IF;
					ELSIF StatusCheckOut = 0 AND StatusCheckIn = 1 THEN;
						INSERT INTO ListNoCheckOut(DateCheck,UserNo,UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													TimeCheckIn,Latitude,Longtitude,IpServer,Distance,TimeLate,SortNo,LatCompany,LngCompany,BeaconInfo,Provider)
										RETURN QUERY
										SELECT /* TOP 1 */ DateCheck,_UserNo, UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo,
													CheckTime,Latitude,Longtitude,IpServer,Distance,0,0,LatCompany,LngCompany,BeaconInfo,Provider
													FROM ReturnWorkingTime
					END IF;
				END IF;

		FETCH NEXT FROM WorkingTime_Cursor
		INTO DateCheck,_UserNo, UserName,UserNameEN,Position,PositionEN,Department,DepartmentEN,PositionSortNo,PositionNo,DutyNo,DutySortNo
		END;
	CLOSE WorkingTime_Cursor
	DEALLOCATE WorkingTime_Cursor

	RETURN QUERY
	SELECT 
		L.UserNo,
		L.UserName,
		L.UserNameEN,
		L.Position,
		L.PositionEN,
		L.Department,
		L.DepartmentEN,
		L.DateCheck,
		L.TimeCheckIn,
		L.TimeLate,
		L.IpServer,
		L.Distance,
		L.Latitude,
		L.Longtitude,
		L.LatCompany,
		L.LngCompany,
		L.PositionSortNo AS "SortNo",
		L.BeaconInfo,
		L.Provider
		FROM ListNoCheckOut L;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
