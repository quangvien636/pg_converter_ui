-- ─── FUNCTION: schedule_getcalendarpermisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarpermisions(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarpermisions(
    p_uno integer
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
BEGIN



		DepartNo INT
	);

	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = schedule_getcalendarpermisions.p_uno
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

	RETURN QUERY
	SELECT CalendarNo, S.UserNo
	FROM ScheduleCalendarPermisions S
	WHERE S.UserNo = schedule_getcalendarpermisions.p_uno
	or s.DepartNo in (select * from DepartNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
