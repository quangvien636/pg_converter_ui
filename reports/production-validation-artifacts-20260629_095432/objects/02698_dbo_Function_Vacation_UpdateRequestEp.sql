-- ─── FUNCTION: vacation_updaterequestep ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_updaterequestep(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updaterequestep(
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_date timestamp without time zone,
    p_typea integer,
    p_td double precision,
    p_uno character varying,
    p_dno character varying,
    p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   set 
           TypeId = vacation_updaterequestep.p_type
           ,Fromd = vacation_updaterequestep.p_from
           ,Tod = vacation_updaterequestep.p_to
		   ,Note = vacation_updaterequestep.p_note
           , TypeForAll =vacation_updaterequestep.p_typea
		   ,TimeDis =vacation_updaterequestep.p_td
		   ,UserNo = vacation_updaterequestep.p_uno
		   ,departno = vacation_updaterequestep.p_dno
where   (',' || p_Uno || ',' ILIKE '%,' || CONVERT(VARCHAR(50),UsernoI)+',%' )
or 
						EXISTS (select d.* from Organization_BelongToDepartment  B  
								INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
								where B.UserNo = UsernoI
								and  ',' || p_Dno || ',' ILIKE '%,' || CONVERT(VARCHAR(50),d.DepartNo)+',%');
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
