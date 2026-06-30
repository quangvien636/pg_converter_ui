-- ─── FUNCTION: schedule_getschedulereport ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getschedulereport(integer, integer, timestamp without time zone, timestamp without time zone, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedulereport(
    userno integer,
    divisionno integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    calendartype integer DEFAULT 3,
    calendarno integer DEFAULT 0,
    iscompleted integer DEFAULT -1,
    currpage integer DEFAULT 1,
    pagesize integer DEFAULT 1000000
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    positionnos table (
		positionno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		DepartNo INT
	);
	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = schedule_getschedulereport.userno
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
	SELECT /* TOP 1 */ PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getschedulereport.userno order by IsDefault desc

	if(DivisionNo >0) 
	BEGIN
		RETURN QUERY
		SELECT * FROM (
			SELECT COUNT(SC.ScheduleNo) OVER() AS TotalCnt,
				 ROW_NUMBER() OVER(ORDER BY SC.RegDate DESC) AS RowNum,
				 SC.ScheduleNo, SC.Title, CL.Name CalendarName, CL.CalendarNo, SC.StartDate, SC.StartTime, SC.EndDate, SC.EndTime, SC.RegDate, SC.IsCompleted,
				 U.Name UserName, U.Name_EN UserName_EN, 
				 D.Name DepartName, D.Name_EN DepartName_EN,SD.Name as DivisionName
			FROM ScheduleContents SC
			--INNER JOIN ScheduleCalendarSetup SS ON SC.RegUserNo = SS.UserNo
			INNER JOIN ScheduleCalendars CL ON SC.CalendarNo = CL.CalendarNo
			INNER JOIN Organization_Users U ON U.UserNo = SC.RegUserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
			INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
			INNER JOIN ScheduleDivisions SD ON SD.DivisionNo=SC.DivisionNo
			--WHERE SS.IsFunctionComplete = TRUE 
				WHERE CL.Type = schedule_getschedulereport.calendartype 
				AND StartDate BETWEEN StartDate AND EndDate
				AND (CL.CalendarNo = schedule_getschedulereport.calendarno OR CalendarNo = 0)
				AND (IsCompleted = -1 OR SC.IsCompleted = schedule_getschedulereport.iscompleted)
				AND SC.DivisionNo=schedule_getschedulereport.divisionno
		) T
		WHERE RowNum BETWEEN ((CurrPage - 1) * PageSize) + 1 AND CurrPage * PageSize
		
	END
	ELSE 
	BEGIN
		RETURN QUERY
		SELECT * FROM (
		SELECT COUNT(SC.ScheduleNo) OVER() AS TotalCnt,
			 ROW_NUMBER() OVER(ORDER BY SC.RegDate DESC) AS RowNum,
			 SC.ScheduleNo, SC.Title, CL.Name CalendarName, CL.CalendarNo, SC.StartDate, SC.StartTime, SC.EndDate, SC.EndTime, SC.RegDate, SC.IsCompleted,
		 U.Name UserName, U.Name_EN UserName_EN, 
		 D.Name DepartName, D.Name_EN DepartName_EN, SD.Name as DivisionName
		FROM ScheduleContents SC
		--INNER JOIN ScheduleCalendarSetup SS ON SC.RegUserNo = SS.UserNo
		INNER JOIN ScheduleCalendars CL ON SC.CalendarNo = CL.CalendarNo
		INNER JOIN Organization_Users U ON U.UserNo = SC.RegUserNo
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		INNER JOIN ScheduleDivisions SD ON SD.DivisionNo=SC.DivisionNo
		--WHERE SS.IsFunctionComplete = TRUE 
			WHERE CL.Type = schedule_getschedulereport.calendartype 
			AND StartDate BETWEEN StartDate AND EndDate
			AND (CL.CalendarNo = schedule_getschedulereport.calendarno OR CalendarNo = 0)
			AND (IsCompleted = -1 OR COALESCE(SC.IsCompleted,0) = schedule_getschedulereport.iscompleted)
			OR (SC.ScheduleNo IN (
				SELECT SCC.ScheduleNo 
				FROM ScheduleCalendarSharers SCS
				INNER JOIN ScheduleCalendars CLS ON SCS.CalendarNo = CLS.CalendarNo
				INNER JOIN ScheduleContents SCC ON SCC.CalendarNo = SCS.CalendarNo
				WHERE CLS.Type = schedule_getschedulereport.calendartype
				AND SCC.StartDate BETWEEN StartDate AND EndDate
				AND (IsCompleted = -1 OR COALESCE(SCC.IsCompleted,0) = schedule_getschedulereport.iscompleted)
				AND (UserNo = schedule_getschedulereport.userno 
				OR DepartNo IN (SELECT * FROM DepartNos)
				OR PositionNo IN (SELECT * FROM PositionNos))
			) AND (SC.CalendarNo = schedule_getschedulereport.calendarno OR CalendarNo = 0))
			) T
		WHERE RowNum BETWEEN ((CurrPage - 1) * PageSize) + 1 AND CurrPage * PageSize
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
