-- ─── PROCEDURE→FUNCTION: schedule_getddaysofmonth ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonth(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonth(
    IN userno integer,
    IN groupno integer,
    IN isshare boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
    positionnos table (
		positionno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

    -- 부서별


	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaysofmonth.userno;
	INSERT INTO DepartNos VALUES(DepartNo)
	

	WHILE 1=1 LOOP
		SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF DepartNo = 0 THEN
			EXIT;
		END IF;
		
		INSERT INTO DepartNos VALUES(DepartNo)
	END LOOP;
	
	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaysofmonth.userno
	
	-- 목록
	IF GroupNo = -1 THEN
		
		IF IsShare = FALSE THEN
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
					S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
					COALESCE(R.RepeatDate,S.DoomDate) As DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType, 
					COALESCE(R.IsComplete,S.IsComplete) As IsComplete, 
					COALESCE(R.CompleteDate, S.CompleteDate) As CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag
						WHERE UserNo = schedule_getddaysofmonth.userno AND GroupNo = S.GroupNo) = 0 THEN 
							COALESCE((
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = S.RegUserNo
								AND GroupNo = S.GroupNo
							 ),0)
						ELSE
							(
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = schedule_getddaysofmonth.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdaysRepeat R ON S.DdayNo = R.DdayNo
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddaysofmonth.userno
			) AS T
			ORDER BY DoomDate
		END IF;
		ELSE
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
					S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
					COALESCE(R.RepeatDate,S.DoomDate) As DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType,
					COALESCE(R.IsComplete,S.IsComplete) As IsComplete, 
					COALESCE(R.CompleteDate, S.CompleteDate) As CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag 
						WHERE UserNo = schedule_getddaysofmonth.userno AND GroupNo = S.GroupNo) = 0 THEN 
							COALESCE((
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = S.RegUserNo
								AND GroupNo = S.GroupNo
							 ),0)
						ELSE
							(
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = schedule_getddaysofmonth.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdaysRepeat R ON S.DdayNo = R.DdayNo
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddaysofmonth.userno
					OR S.DdayNo IN (
						SELECT DdayNo
						FROM ScheduleDdaySharers SDS
						WHERE (SDS.UserNo = schedule_getddaysofmonth.userno OR SDS.DepartNo IN (SELECT * FROM DepartNos) OR SDS.PositionNo IN (SELECT * FROM PositionNos))
						)
			) AS T
			ORDER BY DoomDate
		END IF;
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
				S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
				Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
				COALESCE(R.RepeatDate,S.DoomDate) As DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
				RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
				IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
				DisplayType,
				COALESCE(R.IsComplete,S.IsComplete) As IsComplete, 
				COALESCE(R.CompleteDate, S.CompleteDate) As CompleteDate,
				CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag 
						WHERE UserNo = schedule_getddaysofmonth.userno AND GroupNo = S.GroupNo) = 0 THEN 
							COALESCE((
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = S.RegUserNo
								AND GroupNo = S.GroupNo
							 ),0)
						ELSE
							(
								SELECT TagImageNo 
								FROM ScheduleDdaysTag
								WHERE UserNo = schedule_getddaysofmonth.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
			FROM ScheduleDdays S
			LEFT JOIN ScheduleDdaysRepeat R ON S.DdayNo = R.DdayNo
			LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_getddaysofmonth.userno AND S.GroupNo = schedule_getddaysofmonth.groupno
		) AS T
		ORDER BY DoomDate
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
