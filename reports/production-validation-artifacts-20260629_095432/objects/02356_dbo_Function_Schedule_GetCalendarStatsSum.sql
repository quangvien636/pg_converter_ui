-- ─── FUNCTION: schedule_getcalendarstatssum ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarstatssum(character varying);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarstatssum(
    datefrom character varying
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
	SELECT A.CalendarNo, A.Name, A.Color AS "cColor", COUNT(B.ScheduleNo) AS SchdCnt 
	FROM
	(
		SELECT CalendarNo, Name, Type, Color, UseLevel, Description, IsFixed		
		FROM ScheduleCalendars
		WHERE (RegUserNo = UserNo AND Type = 2) OR CalendarNo IN (
			SELECT CalendarNo FROM ScheduleCalendarSharers
			WHERE UserNo = UserNo OR DepartNo IN (SELECT * FROM DepartNos)
		)
	) A
	LEFT OUTER JOIN ScheduleContents B ON A.CalendarNo = B.CalendarNo
	WHERE CONVERT(VARCHAR(8),B.StartDate,112) BETWEEN DateFrom AND DateTo
	OR B.StartDate IS NULL
	GROUP BY A.CalendarNo, A.Name, A.Color
	ORDER BY COUNT(B.ScheduleNo) DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
