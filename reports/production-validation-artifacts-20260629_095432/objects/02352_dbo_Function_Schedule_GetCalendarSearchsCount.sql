-- ─── FUNCTION: schedule_getcalendarsearchscount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarsearchscount(character varying, character varying, integer, integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarsearchscount(
    calendar_type character varying DEFAULT 'A',
    search_text character varying DEFAULT '',
    schedule_check integer DEFAULT 1,
    todo_check integer DEFAULT 1,
    d_day_check integer DEFAULT 1,
    start_date date DEFAULT '1900-01-01',
    end_date date DEFAULT '9999-12-31'
) RETURNS TABLE(
    positionno text
)
AS $function$
DECLARE
    positionnos table (
		positionno int
	);
BEGIN


		DepartNo INT
	);

	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = UserNo
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
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo
	
	--=============================
	-- 일정 검색
	--=============================

	RETURN QUERY
	SELECT
		COUNT (*) AS SCHD_CNT
	FROM
	(
		SELECT
			A.RegUserNo, 
			A.CalendarNo,
			A.ScheduleNo,
			A.StartDate, 
			A.EndDate,
			A.Title,
			A.Content,
			A.DivisionNo
		FROM ScheduleContents A
		WHERE A.CalendarNo IN (
			SELECT CalendarNo FROM ScheduleCalendars
			WHERE RegUserNo = UserNo 
				--OR Type = 1 
				OR CalendarNo IN (
				SELECT CalendarNo FROM ScheduleCalendarSharers
				WHERE UserNo = UserNo 
				OR DepartNo IN (SELECT * FROM DepartNos)
				OR PositionNo IN (SELECT * FROM PositionNos)
				)
			)
			OR A.ScheduleNo IN (
				SELECT ScheduleNo FROM ScheduleContentSharers
				WHERE UserNo = UserNo 
				OR DepartNo IN (SELECT * FROM DepartNos)
				OR PositionNo IN (SELECT * FROM PositionNos)
			)
	) C
	LEFT JOIN ScheduleDivisions D ON C.DivisionNo = D.DivisionNo
	LEFT JOIN ScheduleCalendars SC ON C.CalendarNo = SC.CalendarNo
	WHERE 1=1
	AND (
			UPPER(C.Title) ILIKE UPPER('%' || SEARCH_TEXT || '%')
			OR
			UPPER(C.Content) ILIKE UPPER('%' || SEARCH_TEXT || '%')
		)
	AND C.StartDate BETWEEN START_DATE AND END_DATE
	AND C.EndDate BETWEEN START_DATE AND END_DATE
	AND SCHEDULE_CHECK = 1
	AND (CALENDAR_TYPE = 'A' OR CONVERT(VARCHAR(1),SC.Type) = schedule_getcalendarsearchscount.calendar_type)
	--========================
	-- 할일검색
	--========================
	RETURN QUERY
	SELECT 
		COUNT(T.ToDoNo) AS TODO_CNT
	FROM ScheduleToDos T
	LEFT JOIN ScheduleToDoGroups G ON T.GroupNo = G.GroupNo
	WHERE (T.RegUserNo = UserNo
	OR T.ToDoNo IN (
		SELECT ToDoNo FROM ScheduleToDoSharers S
		WHERE (S.UserNo = UserNo 
		OR S.DepartNo IN (SELECT DepartNo FROM DepartNos)
		OR S.PositionNo IN (SELECT * FROM PositionNos))
		
	))
	AND UPPER(T.Title) ILIKE UPPER('%' || SEARCH_TEXT || '%')
	AND COALESCE(CompleteDate,CONVERT(DATE,'1900-01-01')) BETWEEN START_DATE AND END_DATE
	AND TODO_CHECK = 1
	AND (CALENDAR_TYPE = 'A' OR CALENDAR_TYPE = 'T')
	--========================
	-- D-Day 검색
	--========================
	RETURN QUERY
	SELECT
		COUNT(D.DdayNo) AS DDAY_CNT
	FROM ScheduleDdays D
	LEFT JOIN ScheduleDdayGroups G ON D.GroupNo = G.GroupNo
	WHERE (D.RegUserNo = UserNo
	OR D.DdayNo IN (
			SELECT DdayNo FROM ScheduleDdaySharers S 
			  WHERE (S.UserNo = UserNo 
			  OR S.DepartNo IN (SELECT DepartNo FROM DepartNos)
			  OR S.PositionNo IN (SELECT PositionNo FROM PositionNos)
			  )
			))
	AND UPPER(D.Title) ILIKE UPPER('%' || SEARCH_TEXT || '%')
	AND D_DAY_CHECK = 1
	AND (CALENDAR_TYPE = 'A' OR CALENDAR_TYPE = 'D');
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
