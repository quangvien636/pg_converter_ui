-- ─── PROCEDURE→FUNCTION: schedule_getschedulereport ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_getschedulereport(integer, integer, timestamp without time zone, timestamp without time zone, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedulereport(
    IN userno integer,
    IN divisionno integer,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone,
    IN calendartype integer DEFAULT 3,
    IN calendarno integer DEFAULT 0,
    IN iscompleted integer DEFAULT -1,
    IN currpage integer DEFAULT 1,
    IN pagesize integer DEFAULT 1000000
) RETURNS SETOF record
AS $function$
DECLARE
    positionnos table (
		positionno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



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
		
	END;
	ELSE
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
