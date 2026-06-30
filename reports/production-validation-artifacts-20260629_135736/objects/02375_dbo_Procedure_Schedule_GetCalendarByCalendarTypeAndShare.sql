-- ─── PROCEDURE→FUNCTION: schedule_getcalendarbycalendartypeandshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getcalendarbycalendartypeandshare(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarbycalendartypeandshare(
    IN userno integer,
    IN calendartype integer
) RETURNS SETOF record
AS $function$
DECLARE
    departnos table (
		departno int
	);
    departno integer;
    positionnos table (
		positionno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SELECT COUNT(*) FROM ScheduleCalendars (NOLOCK THEN
		WHERE IsFixed = TRUE AND RegUserNo = schedule_getcalendarbycalendartypeandshare.userno) = 0 BEGIN
	
		INSERT INTO ScheduleCalendars (
			RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
			IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, SortOrder)
		VALUES (UserNo, NOW(), UserNo, NOW(), '내 일정', 2, 'e55e76', 0, '',
			0, 0, 0, 0, 0, 1, 0)
		
	END;



	SELECT DepartNo INTO departno FROM Organization_BelongToDepartment WHERE UserNo = schedule_getcalendarbycalendartypeandshare.userno

	IF DepartNo IS NOT NULL THEN

		INSERT INTO DepartNos VALUES(DepartNo)
	
		WHILE 1 = 1 LOOP
	
			SELECT ParentNo INTO departno FROM Organization_Departments WHERE DepartNo = DepartNo
		
			IF DepartNo = 0 THEN
				EXIT;
			END IF;
		
			INSERT INTO DepartNos VALUES(DepartNo)
		
		END LOOP;

	END IF;

	-- 직급별

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = schedule_getcalendarbycalendartypeandshare.userno

	RETURN QUERY
	SELECT CalendarNo	
	, Name, Type, Color
	
	, IsFixed, SortOrder, CASE WHEN RegUserNo = schedule_getcalendarbycalendartypeandshare.userno THEN 'Y' ELSE '' END AS IsModYN
	FROM ScheduleCalendars
	WHERE 1=1 
	--AND RegUserNo = UserNo 
	AND Type = schedule_getcalendarbycalendartypeandshare.calendartype 
	
	OR CalendarNo IN (
		SELECT CalendarNo FROM ScheduleCalendarSharers
		WHERE UserNo = schedule_getcalendarbycalendartypeandshare.userno 
		OR DepartNo IN (SELECT * FROM DepartNos)
		OR PositionNo IN (SELECT * FROM PositionNos)
	)
	ORDER BY IsFixed DESC, SortOrder;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
