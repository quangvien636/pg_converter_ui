-- ─── PROCEDURE→FUNCTION: schedule_getschedules ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getschedules(integer, date, date, integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedules(
    IN userno integer,
    IN startdate date,
    IN enddate date,
    IN p_mode integer
) RETURNS SETOF record
AS $function$
DECLARE
    positionnos table (
			positionno int
		);
    calennos table (calendarno int);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

   IF p_mode = 0 THEN


		with name_tree as 
		(
 			SELECT DepartNo, ParentNo FROM Organization_Departments 
			WHERE DepartNo IN (
				SELECT DepartNo FROM Organization_BelongToDepartment 
				WHERE UserNo = schedule_getschedules.userno
			)
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.DepartNo = P.ParentNo  
			AND C.DepartNo<>C.ParentNo 
		) ;
		insert into DepartNos
		RETURN QUERY
		select DepartNo from name_tree

		-- 직급별

		INSERT INTO PositionNos
		RETURN QUERY
		SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getschedules.userno


		insert into CaNo
		RETURN QUERY
		SELECT * FROM(
				SELECT CalendarNo FROM ScheduleCalendarPermisions
				WHERE UserNo = schedule_getschedules.userno 
				OR DepartNo IN (SELECT DepartNo FROM DepartNos where DepartNo <> 0)
				UNION 
				SELECT CalendarNo FROM ScheduleCalendarSharers
				WHERE  DepartNo IN (SELECT * FROM DepartNos)
				OR PositionNo IN (SELECT * FROM PositionNos)
				OR UserNo = schedule_getschedules.userno
		)X;
		----------

		INSERT into CalenNos
		RETURN QUERY
		select * from
		(
			SELECT CalendarNo
			FROM ScheduleCalendars
			WHERE Type <> 5 AND 
			(RegUserNo = schedule_getschedules.userno 
			OR isall = TRUE   ----20230913
			OR CalendarNo IN (SELECT  CaNo FROM CaNo ))
			UNION ALL
			SELECT CalendarNo
			FROM ScheduleCalendars
			WHERE Type = 5 AND 
			(RegUserNo = schedule_getschedules.userno 
			OR CalendarNo IN (SELECT  CaNo FROM CaNo ))
		)y
		----------
		RETURN QUERY
		SELECT ScheduleNo, Title, Content, S.CalendarNo, DivisionNo,
			S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay,
			RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
			StartDate, EndDate, StartTime, EndTime, IsAllDay,
			S.IsNotiNote, S.IsNotiMail, S.IsNotiSMS, S.IsNotiPopup, S.NotiTimeType,
			CASE WHEN RegUserNo = schedule_getschedules.userno THEN 'Y' ELSE '' END ModYN,
			CASE WHEN CONVERT(VARCHAR(8),StartDate,112) < CONVERT(VARCHAR(8),NOW(),112) THEN 'Y' ELSE '' END LastYN,
			U.Name As RegUserName
			,s.Latitude
			,S.Longitude
		FROM ScheduleContents S
		INNER JOIN Organization_Users U ON S.RegUserNo = U.UserNo
		WHERE  s.StartDate <= schedule_getschedules.enddate AND S.EndDate >= schedule_getschedules.startdate  and (S.CalendarNo 
				IN (SELECT CalendarNo FROM CalenNos)
				OR S.ScheduleNo IN (
					SELECT ScheduleNo FROM ScheduleContentSharers
					WHERE UserNo = schedule_getschedules.userno 
					OR DepartNo IN (SELECT DepartNo FROM DepartNos)
					OR PositionNo IN (SELECT PositionNo FROM PositionNos)
				)
			)
		ORDER BY StartDate, StartTime, IsAllDay
	END IF;
	ELSE
		RETURN QUERY
		SELECT ScheduleNo, Title, Content, S.CalendarNo, DivisionNo,
			S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay,
			RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
			StartDate, EndDate, StartTime, EndTime, IsAllDay,
			S.IsNotiNote, S.IsNotiMail, S.IsNotiSMS, S.IsNotiPopup, S.NotiTimeType,
			CASE WHEN RegUserNo = schedule_getschedules.userno THEN 'Y' ELSE '' END ModYN,
			CASE WHEN CONVERT(VARCHAR(8),StartDate,112) < CONVERT(VARCHAR(8),NOW(),112) THEN 'Y' ELSE '' END LastYN,
			U.Name As RegUserName
			,s.Latitude
			,S.Longitude
		FROM ScheduleContents S
		INNER JOIN Organization_Users U ON S.RegUserNo = U.UserNo
		WHERE  s.StartDate <= schedule_getschedules.enddate AND S.EndDate >= schedule_getschedules.startdate  
		ORDER BY StartDate, StartTime, IsAllDay
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
