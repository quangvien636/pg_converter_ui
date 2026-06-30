-- ─── FUNCTION: schedule_getcalendarsgoogle ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarsgoogle();
CREATE OR REPLACE FUNCTION public.schedule_getcalendarsgoogle(
) RETURNS TABLE(
    belongno bigserial,
    userno integer,
    departno integer,
    positionno integer,
    dutyno integer,
    isdefault boolean
)
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
BEGIN



	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo;
	INSERT INTO DepartNos VALUES(DepartNo)
	
	WHILE 1 = 1 BEGIN
	
		SELECT DepartNo = ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF (DepartNo = 0) BEGIN
			BREAK	
		END
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END
	RETURN QUERY
	SELECT A.CalendarNo, Name, Type, Color, Description, COALESCE(SCG.GoogleCalendarID,'') AS GoogleCalendarID, IsModYN
	FROM (
		SELECT 
			0 AS CalendarNo, 
			'공유받은 일정' As Name,
			2 AS Type, 
			'a1ba46' AS Color,
			'' As Description, 
			'' As IsModYN
	) A
	LEFT JOIN ScheduleCalendarsGoogle SCG ON SCG.UserNo = UserNo ANd SCG.CalendarNo = 0
	UNION ALL
	RETURN QUERY
	SELECT SC.CalendarNo, Name, Type, Color, Description, COALESCE(SCG.GoogleCalendarID,'') AS GoogleCalendarID,
		CASE WHEN RegUserNo = UserNo THEN 'Y' ELSE '' END AS IsModYN
	FROM ScheduleCalendars SC
	LEFT JOIN ScheduleCalendarsGoogle SCG ON SC.CalendarNo = SCG.CalendarNo AND SCG.UserNo = UserNo
	WHERE RegUserNo = UserNo OR Type = 1 OR SC.CalendarNo IN (
		SELECT CalendarNo FROM ScheduleCalendarSharers
		WHERE UserNo = UserNo OR DepartNo IN (SELECT * FROM DepartNos)
	)
	ORDER BY Type;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
