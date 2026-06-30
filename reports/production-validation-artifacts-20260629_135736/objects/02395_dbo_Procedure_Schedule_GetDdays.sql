-- ─── PROCEDURE→FUNCTION: schedule_getddays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddays(integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getddays(
    IN userno integer,
    IN groupno integer,
    IN viewcount integer,
    IN currentpageindex integer,
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


	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddays.userno

	IF DepartNo IS NOT NULL THEN

		INSERT INTO DepartNos VALUES(DepartNo)

		WHILE 1 = 1 LOOP

			SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
			IF DepartNo = 0 THEN
				EXIT;
			END IF;
		
			INSERT INTO DepartNos VALUES(DepartNo)
		
		END LOOP;

	END IF;

	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getddays.userno
	
	-- 목록
	IF GroupNo = -1 THEN
		
		IF IsShare = FALSE THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
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
