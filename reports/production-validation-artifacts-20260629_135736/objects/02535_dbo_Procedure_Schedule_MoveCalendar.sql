-- ─── PROCEDURE→FUNCTION: schedule_movecalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_movecalendar(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_movecalendar(
    IN mode character varying,
    IN calendartype integer,
    IN curridx integer,
    IN moveidx integer
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
	union all 
	RETURN QUERY
	select DepartNo from ScheduleCalendarPermisions

	-- 직급별


	insert into UseNos
	RETURN QUERY
	select UserNo from ScheduleCalendarPermisions
	union all select UserNo;

	INSERT INTO PositionNos
	RETURN QUERY
	SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo;
	With cte As
	(
		SELECT CalendarNo,SortOrder,
		ROW_NUMBER() OVER (ORDER BY COALESCE(SortOrder,0) ASC) AS RN
		FROM ScheduleCalendars 
		WHERE RegUserNo = UserNo OR isall = TRUE OR CalendarNo IN (
				SELECT CalendarNo FROM ScheduleCalendarSharers
				WHERE UserNo in (select UserNo from UseNos )
				OR DepartNo IN (SELECT * FROM DepartNos)
				OR PositionNo IN (SELECT * FROM PositionNos)
		)
		AND Type=schedule_movecalendar.calendartype
	);
	UPDATE cte SET SortOrder=RN;

	IF Mode = 'UF' THEN;
		UPDATE ScheduleCalendars
		SortOrder := -1;
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
	END IF;
	IF Mode = 'U' THEN;
		UPDATE ScheduleCalendars
		SortOrder := SortOrder - 1.01;
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
		
	END IF;
	IF Mode = 'D' THEN;
		UPDATE ScheduleCalendars
		SortOrder := SortOrder + 1.01;
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
	END IF;
	IF Mode = 'DL' THEN;
		UPDATE ScheduleCalendars
		SortOrder := 9999;
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
