-- ─── FUNCTION: schedule_getddays ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddays(integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddays(
    userno integer,
    groupno integer,
    viewcount integer,
    currentpageindex integer,
    isshare boolean DEFAULT FALSE
) RETURNS TABLE(
    tagimageno text
)
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
    positionnos table (
		positionno int
	);
BEGIN


    -- 부서별


	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddays.userno

	IF (DepartNo IS NOT NULL) BEGIN

		INSERT INTO DepartNos VALUES(DepartNo)

		WHILE 1 = 1 BEGIN

			SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
			IF (DepartNo = 0) BEGIN
				BREAK	
			END
		
			INSERT INTO DepartNos VALUES(DepartNo)
		
		END

	END

	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddays.userno
	
	-- 목록
	IF GroupNo = -1 BEGIN
		
		IF IsShare = FALSE
		BEGIN
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
					DdayNo, S.RegUserNo, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, DG.Name AS GroupName,
					DoomDate, S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType, IsComplete, CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag
						WHERE UserNo = schedule_getddays.userno AND GroupNo = S.GroupNo) = 0 THEN 
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
								WHERE UserNo = schedule_getddays.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddays.userno
			) AS T
			--WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY DoomDate
		END
		ELSE 
		BEGIN
			RETURN QUERY
			SELECT * FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
					DdayNo, S.RegUserNo, S.RegDate, S.ModUserNo, S.ModDate,
					Title, S.Contents, S.GroupNo, DG.Name AS GroupName,
					DoomDate, S.IsLunar, S.IsHoliday, S.IsLastDay, PeriodYear,
					RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
					IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
					DisplayType, IsComplete, CompleteDate,
					CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag
						WHERE UserNo = schedule_getddays.userno AND GroupNo = S.GroupNo) = 0 THEN 
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
								WHERE UserNo = schedule_getddays.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
				FROM ScheduleDdays S
				LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
				WHERE S.RegUserNo = schedule_getddays.userno
					OR S.DdayNo IN (
						SELECT DdayNo
						FROM ScheduleDdaySharers SDS
						WHERE (SDS.UserNo = schedule_getddays.userno OR SDS.DepartNo IN (SELECT * FROM DepartNos) OR SDS.PositionNo IN (SELECT * FROM PositionNos))
						)
			) AS T
			--WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY DoomDate
		END
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT * FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY S.RegDate DESC) AS RowNum,
				DdayNo, S.RegUserNo, S.RegDate, S.ModUserNo, S.ModDate,
				Title, S.Contents, S.GroupNo, DG.Name AS GroupName,
				DoomDate, S.IsLunar, S.IsHoliday, S.IsLastDay, PeriodYear,
				RepeatEndDate, RepeatType, RepeatCount, RepeatMonth ,RepeatWeek ,RepeatDay, RepeatDOWs,
				IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
				DisplayType, IsComplete, CompleteDate,
				CASE WHEN (
						SELECT COUNT(TagImageNo) 
						FROM ScheduleDdaysTag
						WHERE UserNo = schedule_getddays.userno AND GroupNo = S.GroupNo) = 0 THEN 
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
								WHERE UserNo = schedule_getddays.userno
								AND GroupNo = S.GroupNo
							)  
					END AS TagImageNo
			FROM ScheduleDdays S
			LEFT JOIN ScheduleDdayGroups DG ON DG.GroupNo = S.GroupNo
			WHERE S.RegUserNo = schedule_getddays.userno AND S.GroupNo = schedule_getddays.groupno
		) AS T
		--WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		ORDER BY DoomDate
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
