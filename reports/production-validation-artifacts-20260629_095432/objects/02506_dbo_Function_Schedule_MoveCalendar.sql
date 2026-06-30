-- ─── FUNCTION: schedule_movecalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movecalendar(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_movecalendar(
    mode character varying,
    calendartype integer,
    curridx integer,
    moveidx integer
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
	union all 
	RETURN QUERY
	select DepartNo from ScheduleCalendarPermisions

	-- 직급별


		UNo INT
	);;
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

	IF Mode = 'UF'
	BEGIN;
		UPDATE ScheduleCalendars
		SET 
			SortOrder = -1
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
	END
	IF Mode = 'U'
	BEGIN;
		UPDATE ScheduleCalendars
		SET 
			SortOrder =  SortOrder - 1.01
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
		
	END
	IF Mode = 'D'
	BEGIN;
		UPDATE ScheduleCalendars
		SET 
			SortOrder =  SortOrder + 1.01
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
	END
	IF Mode = 'DL'
	BEGIN;
		UPDATE ScheduleCalendars
		SET 
			SortOrder = 9999
		WHERE Type=schedule_movecalendar.calendartype
		AND CalendarNo = CalendarNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
