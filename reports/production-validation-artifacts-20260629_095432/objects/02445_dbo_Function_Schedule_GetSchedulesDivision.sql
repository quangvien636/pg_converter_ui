-- ─── FUNCTION: schedule_getschedulesdivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getschedulesdivision(integer, date, date, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedulesdivision(
    userno integer,
    startdate date,
    enddate date,
    divisionno integer,
    p_mode integer
) RETURNS TABLE(
    scheduleno text,
    title text,
    content text,
    calendarno text,
    divisionno text,
    islunar text,
    isholiday text,
    isfiveweek text,
    islastday text,
    repeattype text,
    repeatcount text,
    repeatmonth text,
    repeatweek text,
    repeatday text,
    repeatdows text,
    startdate text,
    enddate text,
    starttime text,
    endtime text,
    isallday text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text,
    notitimetype text,
    col26 text,
    col27 text,
    regusername text,
    latitude text,
    longitude text
)
AS $function$
DECLARE
    positionnos table (
			positionno int
		);
    calennos table (calendarno int);
BEGIN

 if(p_mode = 0)
 begin

		with name_tree as 
		(
			SELECT DepartNo, ParentNo FROM Organization_Departments 
					WHERE DepartNo IN (
				SELECT DepartNo FROM Organization_BelongToDepartment 
				WHERE UserNo = schedule_getschedulesdivision.userno
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
		union all 
		RETURN QUERY
		select DepartNo from ScheduleCalendarPermisions

		-- 직급별


			UNo INT
		);;
		insert into UseNos
		RETURN QUERY
		select UserNo from ScheduleCalendarPermisions
		union all select UserNo;

		INSERT INTO PositionNos
		RETURN QUERY
		SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getschedulesdivision.userno

		----------

		INSERT into CalenNos
		RETURN QUERY
		select * from(
		SELECT CalendarNo
		FROM ScheduleCalendars
		WHERE Type <> 5 AND 
		(RegUserNo = schedule_getschedulesdivision.userno 
		OR isall = TRUE   ----20230913
		OR CalendarNo IN (
			SELECT CalendarNo FROM ScheduleCalendarSharers
			WHERE UserNo in (
		select UserNo from UseNos
			)
			OR DepartNo IN (SELECT * FROM DepartNos)
			OR PositionNo IN (SELECT * FROM PositionNos)
		))
		UNION ALL
		SELECT CalendarNo
		FROM ScheduleCalendars
		WHERE Type = 5 AND 
		(RegUserNo = schedule_getschedulesdivision.userno 
		OR CalendarNo IN (
			SELECT CalendarNo FROM ScheduleCalendarSharers
			WHERE DepartNo IN (SELECT * FROM DepartNos)
		))
		)x
		----------

		RETURN QUERY
		SELECT ScheduleNo, Title, Content, S.CalendarNo, DivisionNo,
			S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay,
			RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
			StartDate, EndDate, StartTime, EndTime, IsAllDay,
			S.IsNotiNote, S.IsNotiMail, S.IsNotiSMS, S.IsNotiPopup, S.NotiTimeType,
			CASE WHEN RegUserNo = schedule_getschedulesdivision.userno THEN 'Y' ELSE '' END ModYN,
			CASE WHEN CONVERT(VARCHAR(8),StartDate,112) < CONVERT(VARCHAR(8),NOW(),112) THEN 'Y' ELSE '' END LastYN,
			U.Name As RegUserName
			,s.Latitude
			,S.Longitude
		FROM ScheduleContents S
		INNER JOIN Organization_Users U ON S.RegUserNo = U.UserNo
		WHERE s.StartDate <= schedule_getschedulesdivision.enddate AND S.EndDate >= schedule_getschedulesdivision.startdate and s.DivisionNo = schedule_getschedulesdivision.divisionno
		and (S.CalendarNo IN (SELECT CalendarNo FROM CalenNos )
			   OR S.ScheduleNo IN (
					SELECT ScheduleNo FROM ScheduleContentSharers
					WHERE UserNo = schedule_getschedulesdivision.userno 
					OR DepartNo IN (SELECT DepartNo FROM DepartNos)
					OR PositionNo IN (SELECT PositionNo FROM PositionNos)
				)
			)
		ORDER BY StartDate, StartTime, IsAllDay
	end
	else
	begin
	 	RETURN QUERY
	 	SELECT ScheduleNo, Title, Content, S.CalendarNo, DivisionNo,
			S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay,
			RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
			StartDate, EndDate, StartTime, EndTime, IsAllDay,
			S.IsNotiNote, S.IsNotiMail, S.IsNotiSMS, S.IsNotiPopup, S.NotiTimeType,
			CASE WHEN RegUserNo = schedule_getschedulesdivision.userno THEN 'Y' ELSE '' END ModYN,
			CASE WHEN CONVERT(VARCHAR(8),StartDate,112) < CONVERT(VARCHAR(8),NOW(),112) THEN 'Y' ELSE '' END LastYN,
			U.Name As RegUserName
			,s.Latitude
			,S.Longitude
		FROM ScheduleContents S
		INNER JOIN Organization_Users U ON S.RegUserNo = U.UserNo
		WHERE s.StartDate <= schedule_getschedulesdivision.enddate AND S.EndDate >= schedule_getschedulesdivision.startdate and s.DivisionNo = schedule_getschedulesdivision.divisionno
		ORDER BY StartDate, StartTime, IsAllDay
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
