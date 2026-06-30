-- ─── PROCEDURE→FUNCTION: schedule_getschedulereportall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_getschedulereportall(integer, integer, timestamp without time zone, timestamp without time zone, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedulereportall(
    IN p_uno integer,
    IN p_dno integer,
    IN p_start timestamp without time zone,
    IN p_end timestamp without time zone,
    IN p_type integer DEFAULT 3,
    IN p_no integer DEFAULT 0,
    IN p_iscm integer DEFAULT -1,
    IN p_page integer DEFAULT 1,
    IN p_size integer DEFAULT 1000000
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
			WHERE UserNo = schedule_getschedulereportall.p_uno
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
	SELECT /* TOP 1 */ PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getschedulereportall.p_uno order by IsDefault desc;

	BEGIN
		RETURN QUERY
		SELECT * FROM (
			SELECT COUNT(SC.ScheduleNo) OVER() AS TotalCnt,
				 ROW_NUMBER() OVER(ORDER BY SC.RegDate DESC) AS RowNum,
				 SC.ScheduleNo, SC.Title, CL.Name CalendarName, CL.CalendarNo, SC.StartDate, SC.StartTime, SC.EndDate, SC.EndTime, SC.RegDate, SC.IsCompleted,
				 U.Name UserName, U.Name_EN UserName_EN, 
				 D.Name DepartName, D.Name_EN DepartName_EN,SD.Name as DivisionName
				 , CASE WHEN p_lang = 'VN' THEN COALESCE(C.NameVn,COALESCE(C.Name,'')) 
					WHEN  p_lang = 'JP' THEN COALESCE(C.NameJp,COALESCE(C.Name,'')) 
					WHEN  p_lang = 'CH' THEN COALESCE(C.NameCh,COALESCE(C.Name,'')) 
					WHEN  p_lang = 'EN' THEN COALESCE(C.NameEn,COALESCE(C.Name,'')) 
				ELSE COALESCE(C.Name,'') END AS CycleName
			FROM ScheduleContents SC
			--INNER JOIN ScheduleCalendarSetup SS ON SC.RegUserNo = SS.UserNo
			INNER JOIN ScheduleCalendars CL ON SC.CalendarNo = CL.CalendarNo
			INNER JOIN Organization_Users U ON U.UserNo = SC.RegUserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
			INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
			INNER JOIN ScheduleDivisions SD ON SD.DivisionNo=SC.DivisionNo
			left join ScheduleCycles c on sc.CycleNo = c.CycleNo
			WHERE CL.Type = schedule_getschedulereportall.p_type 
				AND StartDate BETWEEN p_Start AND p_End
				AND (CL.CalendarNo = schedule_getschedulereportall.p_no OR p_No = 0)
				AND (p_Iscm = -1 OR SC.IsCompleted = schedule_getschedulereportall.p_iscm)
				AND (SC.DivisionNo=schedule_getschedulereportall.p_dno or p_Dno = 0)
				AND (u.UserNo = schedule_getschedulereportall.p_uno 
				OR d.DepartNo IN (SELECT * FROM DepartNos)
				OR b.PositionNo IN (SELECT * FROM PositionNos))
		) T
		WHERE RowNum BETWEEN ((p_page - 1) * p_Size) + 1 AND p_page * p_Size
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
