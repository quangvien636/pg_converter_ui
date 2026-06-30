-- ─── FUNCTION: schedule_getcalendarsearchs ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarsearchs(character varying, character varying, integer, integer, integer, date, date, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarsearchs(
    calendar_type character varying DEFAULT 'A',
    search_text character varying DEFAULT '',
    schedule_check integer DEFAULT 1,
    todo_check integer DEFAULT 1,
    d_day_check integer DEFAULT 1,
    start_date date DEFAULT '1900-01-01',
    end_date date DEFAULT '9999-12-31',
    page_size integer DEFAULT 10,
    schd_page integer DEFAULT 1,
    todo_page integer DEFAULT 1,
    dday_page integer DEFAULT 1
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
		*
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY C.StartDate ASC) AS RowNum,
			C.CalendarNo,
			C.ScheduleNo,
			C.StartDate, 
			C.Title,
			D.Name AS DivName,
			SC.Color AS CalColor,
			SC.Name AS CalName,
			SC.Type AS CalendarType
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
		AND (CALENDAR_TYPE = 'A' OR CONVERT(VARCHAR(1),SC.Type) = schedule_getcalendarsearchs.calendar_type)
	) A
	WHERE RowNum BETWEEN ((SCHD_PAGE-1) * PAGE_SIZE + 1) AND (SCHD_PAGE * PAGE_SIZE)  
	--ORDER BY RowNum
	--========================
	-- 할일검색
	--========================
	RETURN QUERY
	SELECT
		*
	FROM
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY T.CompleteDate ASC) AS RowNum,
			T.ToDoNo,
			T.Important,
			CASE WHEN T.RegUserNo <> UserNo THEN '(공유) ' || T.Title ELSE T.Title END Title,
			COALESCE(G.Name,'미지정') AS GroupName,
			T.IsComplete,
			T.CompleteDate,
			T.ProgressRate
		FROM ScheduleToDos T
		LEFT JOIN ScheduleToDoGroups G ON T.GroupNo = G.GroupNo
		WHERE (T.RegUserNo = UserNo
		OR T.ToDoNo IN (
			SELECT ToDoNo FROM ScheduleToDoSharers S
			WHERE (S.UserNo = UserNo 
			OR S.DepartNo IN (SELECT DepartNo FROM DepartNos)
			OR S.PositionNo IN (SELECT PositionNo FROM PositionNos)
			)
			
		))
		AND UPPER(T.Title) ILIKE UPPER('%' || SEARCH_TEXT || '%')
		AND COALESCE(CompleteDate,CONVERT(DATE,'1900-01-01')) BETWEEN START_DATE AND END_DATE
		AND TODO_CHECK = 1
		AND (CALENDAR_TYPE = 'A' OR CALENDAR_TYPE = 'T')
	) A
	WHERE RowNum BETWEEN ((TODO_PAGE-1) * PAGE_SIZE + 1) AND (TODO_PAGE * PAGE_SIZE)  
	--========================
	-- D-Day 검색
	--========================
	RETURN QUERY
	SELECT
		*
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY D.DoomDate ASC) AS RowNum,
			D.DdayNo,
			D.DoomDate,
			CASE WHEN D.RegUserNo <> UserNo THEN '(공유) ' || D.Title ELSE D.Title END Title,
			COALESCE(G.Name,'미지정') AS GroupName,
			CASE WHEN D.PeriodYear = 9999 THEN '반복' 
				ELSE CONVERT(VARCHAR(4),D.PeriodYear) + '년'
			END AS Range,
			RepeatEndDate,
			RepeatType,
			RepeatCount,
			RepeatMonth,
			RepeatWeek,
			RepeatDay,
			RepeatDOWs
		FROM ScheduleDdays D
		LEFT JOIN ScheduleDdayGroups G ON D.GroupNo = G.GroupNo
		WHERE (D.RegUserNo = UserNo
		OR D.DdayNo IN (
			SELECT DdayNo FROM ScheduleDdaySharers S 
			  WHERE (
			  S.UserNo = UserNo 
			  OR S.DepartNo IN (SELECT DepartNo FROM DepartNos)
			  OR S.PositionNo IN (SELECT PositionNo FROM PositionNos)
			  )
			))
		AND UPPER(D.Title) ILIKE UPPER('%' || SEARCH_TEXT || '%')
		AND D_DAY_CHECK = 1
		AND (CALENDAR_TYPE = 'A' OR CALENDAR_TYPE = 'D')
	) A
	WHERE RowNum  BETWEEN ((DDAY_PAGE-1) * PAGE_SIZE + 1) AND (DDAY_PAGE * PAGE_SIZE);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
