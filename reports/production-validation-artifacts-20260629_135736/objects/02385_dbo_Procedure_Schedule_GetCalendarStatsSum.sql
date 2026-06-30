-- ─── PROCEDURE→FUNCTION: schedule_getcalendarstatssum ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getcalendarstatssum(character varying);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarstatssum(
    IN datefrom character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = UserNo;
	INSERT INTO DepartNos VALUES(DepartNo)
	
	WHILE 1 = 1 LOOP
	
		SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
		IF DepartNo = 0 THEN
			EXIT;
		END IF;
		
		INSERT INTO DepartNos VALUES(DepartNo)
		
	END LOOP;
	
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
