-- ─── FUNCTION: schedule_getddaysofmonth_new ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonth_new(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonth_new(
    userno integer,
    groupno integer,
    curentdate timestamp without time zone,
    isshare boolean DEFAULT FALSE
) RETURNS TABLE(
    belongno bigserial,
    userno integer,
    departno integer,
    positionno integer,
    dutyno integer,
    isdefault boolean
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
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



	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaysofmonth_new.userno;
	INSERT INTO DepartNos VALUES(DepartNo)
	

	WHILE 1=1
	BEGIN
		SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF (DepartNo = 0) BEGIN
			BREAK	
		END
		
		INSERT INTO DepartNos VALUES(DepartNo)
	END
	
	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddaysofmonth_new.userno
	
	-- 목록
		IF GroupNo = -1 BEGIN
		
		IF IsShare = FALSE
		BEGIN
			RETURN QUERY
			SELECT ROW_NUMBER() OVER (ORDER BY RegDate DESC) AS RowNum, * FROM (
				SELECT S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
					S.DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType, 
					S.IsComplete, 
					 S.CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag
						WHERE UserNo = schedule_getddaysofmonth_new.userno AND GroupNo = S.GroupNo) = 0 THEN 
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
								WHERE UserNo = schedule_getddaysofmonth_new.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddaysofmonth_new.userno
			) AS T
			WHERE DoomDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND DoomDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1)
				OR DoomDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND IsComplete = ''
				OR DoomDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND IsComplete = 'Y'AND CompleteDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND CompleteDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1)
			ORDER BY DoomDate
		END
		ELSE 
		BEGIN
			RETURN QUERY
			SELECT ROW_NUMBER() OVER (ORDER BY RegDate DESC) AS RowNum,* FROM (
				SELECT S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
					S.DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType,
					S.IsComplete, 
					S.CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag 
						WHERE UserNo = schedule_getddaysofmonth_new.userno AND GroupNo = S.GroupNo) = 0 THEN 
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
								WHERE UserNo = schedule_getddaysofmonth_new.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddaysofmonth_new.userno
					OR S.DdayNo IN (
						SELECT DdayNo
						FROM ScheduleDdaySharers SDS
						WHERE (SDS.UserNo = schedule_getddaysofmonth_new.userno OR SDS.DepartNo IN (SELECT * FROM DepartNos) OR SDS.PositionNo IN (SELECT * FROM PositionNos))
						)
			) AS T 
			WHERE DoomDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND DoomDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1)
				OR DoomDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND IsComplete = ''
				OR DoomDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND IsComplete = 'Y'AND CompleteDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND CompleteDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1)
			ORDER BY DoomDate 
		END
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ROW_NUMBER() OVER (ORDER BY RegDate DESC) AS RowNum,* FROM (
						SELECT S.DdayNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) AS RegUserName, S.RegDate, S.ModUserNo, S.ModDate,
							Title, S.Contents, S.GroupNo, COALESCE(DG.Name,'') AS GroupName,
							S.DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
							RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
							IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
							DisplayType,
							S.IsComplete, 
							S.CompleteDate,
							CASE WHEN (
								SELECT COUNT(TagImageNo) 
								FROM ScheduleDdaysTag 
								WHERE UserNo = schedule_getddaysofmonth_new.userno AND GroupNo = S.GroupNo) = 0 THEN 
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
										WHERE UserNo = schedule_getddaysofmonth_new.userno
										AND GroupNo = S.GroupNo
									)  
							END AS TagImageNo
						FROM ScheduleDdays S
						LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
						WHERE S.RegUserNo = schedule_getddaysofmonth_new.userno
							OR S.DdayNo IN (
								SELECT DdayNo
								FROM ScheduleDdaySharers SDS
								WHERE (SDS.UserNo = schedule_getddaysofmonth_new.userno OR SDS.DepartNo IN (SELECT * FROM DepartNos) OR SDS.PositionNo IN (SELECT * FROM PositionNos))
								)
					) AS T 
					WHERE GroupNo = schedule_getddaysofmonth_new.groupno 
					AND (DoomDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND DoomDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1)
						OR DoomDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND IsComplete = ''
						OR DoomDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND IsComplete = 'Y'AND CompleteDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND CompleteDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1))
					ORDER BY DoomDate 
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
