-- ─── PROCEDURE→FUNCTION: workingtime_reports ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_reports(integer, character varying, character varying, integer, integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_reports(
    IN userno integer,
    IN fromdate character varying,
    IN todate character varying,
    IN departno integer DEFAULT 0,
    IN p_groupno integer DEFAULT 0,
    IN usertype integer DEFAULT 3,
    IN viewcount integer DEFAULT 50,
    IN currentpageindex integer DEFAULT 1,
    IN p_uid character varying DEFAULT '',
    IN p_uname character varying DEFAULT '',
    IN p_unameen character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
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
		DutySortNo			INT,
		BirthDate			DATETIME,

		Name_CH				NVARCHAR(100),
		Name_JP				NVARCHAR(100),
		Name_VN				NVARCHAR(100),

		DepartName_CH		NVARCHAR(100),
		DepartName_JP		NVARCHAR(100),
		DepartName_VN		NVARCHAR(100),
		
		PositionName_CH		NVARCHAR(100),
		PositionName_JP		NVARCHAR(100),
		PositionName_VN		NVARCHAR(100),

		DutyName_CH			NVARCHAR(100),
		DutyName_JP			NVARCHAR(100),
		DutyName_VN			NVARCHAR(100),
		--GID int,
		TimeIn char(4),
		TimeOffset float
	)


	insert into ListOfUsers
			RETURN QUERY
			SELECT 

				B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
				D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
				P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
				COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo,
				U.BirthDate
				,U.Name_CH,U.Name_JP,U.Name_VN
				,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
				,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
				,COALESCE(DT.Name_CH, '') AS DutyName_CH,COALESCE(DT.Name_JP, '') AS DutyName_JP,COALESCE(DT.Name_VN, '') AS DutyName_VN
				,COALESCE(G.TimeIn,ST1.SettingValue) TimeIn
				,(cast(SUBSTRING(ST3.SettingValue,1,3) as int)*60+cast(SUBSTRING(ST3.SettingValue,5,2) as int))/ 60 TimeOffset
			FROM Organization_BelongToDepartment B 
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 1) ST1 ON 1 = 1
			LEFT JOIN (SELECT  SettingValue FROM WorkingTime_Settings where SettingNo = 7) ST3 ON 1 = 1
			WHERE (DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(DepartNo, 0)))
			AND B.IsDefault = TRUE
			AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_reports.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_reports.p_groupno))
			AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
			AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
			AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')
	---------------------------- End Filter user hide when no permission-------------------------

	IF NOW() < CONVERT(DATETIME, ToDate, 1) SET ToDate = CONVERT(VARCHAR, NOW(), 112) THEN


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
		TimeOffset float = 0

	,
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
		TotalEdit			INT
	)

	,
		TimeOffset float
	)

	--------------------------------------------------------------------------------------------------------------------

	--SET OffSetCompany = (SELECT SettingValue FROM WorkingTime_Settings WHERE SettingNo = 7)

	WorkingTime_Cursor := CURSOR FAST_FORWARD;
		FOR SELECT UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN,TimeIn, TimeOffset FROM ListOfUsers
	OPEN WorkingTime_Cursor
	FETCH NEXT FROM WorkingTime_Cursor
	INTO _UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN,TimeIn, TimeOffset
	WHILE @FETCH_STATUS = 0 BEGIN

		DELETE FROM ReturnWorkingTime;
		INSERT INTO ReturnWorkingTime(WorkingNo,WorkingDay, CheckTime, TimeType, Provider, Status, StarWorking,TimeOffset)
		RETURN QUERY
		SELECT wt.WorkingNo, wt2.WorkingDayOfCompany, wt2.CheckDateTimeOffset, wt.TimeType, wt.Provider, COALESCE(wr.Status, 1) AS Status
			   ,COALESCE(WT.StarWorking,TimeIn) ,COALESCE(WT.TimeOffset,TimeOffset) 
		FROM WorkingTime_Times wt 
		INNER JOIN WorkingTime_Times_v2 wt2 ON wt.WorkingNo = wt2.WorkingNo
		LEFT JOIN WorkingTime_RequestCorrectionTime wr ON wt.WorkingNo = wr.WorkingNo 
		WHERE wt2.WorkingDayOfCompany BETWEEN FromDate AND ToDate AND wt.UserNo = _UserNo AND wt.TimeType IN (1, 3, 8, 6)
		and COALESCE(wt.status,0) != 1
		ORDER BY wt2.CheckDateTimeOffset ASC

		TotalNoCheckIn := 0;
		TotalNoCheckOut := 0;
		TotalLate := 0;
		TotalEdit := 0;
		SELECT  INTO  FROM (SELECT _UserNo AS UserNo FROM ReturnWorkingTime WHERE Status = 1 AND (TimeType = 1 OR TimeType = 8) GROUP BY WorkingDay) AS CheckIn

		SELECT  INTO  FROM (SELECT _UserNo AS UserNo FROM ReturnWorkingTime WHERE Status = 1 AND (TimeType = 3 OR TimeType = 6) GROUP BY WorkingDay) AS CheckOut

		
			WITH CTE AS (
				SELECT *, RN = ROW_NUMBER() OVER (PARTITION BY WorkingDay ORDER BY CheckTime)
				FROM ReturnWorkingTime 
				WHERE Status = 1 AND (TimeType = 1 OR TimeType = 8 )
			)
		
			SELECT COUNT(*) INTO totallate FROM CTE 
			WHERE DATEPART(Minute, CheckTime)+ DATEPART(Hour, CheckTime)*60 > 
				  (cast(LEFT(StarWorking,2) as int)*60+ cast(SUBSTRING(StarWorking,3,2) as int))
				  AND RN = 1	
								

		END IF;
		
		SELECT COUNT(*) INTO totaledit FROM ReturnWorkingTime WHERE Provider = 999 GROUP BY WorkingDay) AS Edit

		IF (TotalNoCheckIn < 0) SET TotalNoCheckIn = 0 THEN
		IF (TotalNoCheckOut < 0) SET TotalNoCheckOut = 0 THEN
		IF (TotalLate < 0) SET TotalLate = 0 THEN
		IF (TotalEdit < 0) SET TotalEdit = 0 THEN

		INSERT INTO ListOfReport (UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit)
		VALUES (_UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit) 

		FETCH NEXT FROM WorkingTime_Cursor
			INTO _UserNo, UserID, Name, Name_EN, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN,TimeIn, TimeOffset
		END;

	CLOSE WorkingTime_Cursor
	DEALLOCATE WorkingTime_Cursor


	IF(ViewCount = -1)
		RETURN QUERY
		SELECT UserNo, Name, Name_EN, UserID, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit FROM ListOfReport
	END IF;
	ELSE
		RETURN QUERY
		SELECT UserNo, Name, Name_EN, UserID, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit FROM(
		SELECT UserNo, Name, Name_EN, UserID, DepartName, DepartName_EN, PositionName, PositionName_EN, DutyName, DutyName_EN, TotalNoCheckIn, TotalNoCheckOut, TotalLate, TotalEdit,
		ROW_NUMBER() OVER ( ORDER BY UserNo ) AS RowNum 
		FROM ListOfReport
		) L
		WHERE L.RowNum BETWEEN ((CurrentPageIndex - 1)*ViewCount+1) AND (CurrentPageIndex*ViewCount)
	END IF;
	

	RETURN QUERY
	SELECT
		COUNT(UserNo) AS TotalStaff,
		COALESCE(SUM(TotalNoCheckIn),0) AS TotalNoCheckIn,
		COALESCE(SUM(TotalNoCheckOut),0) AS TotalNoCheckOut,
		COALESCE(SUM(TotalLate),0) AS TotalLate,
		COALESCE(SUM(TotalEdit),0) AS TotalEdit  FROM ListOfReport;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
