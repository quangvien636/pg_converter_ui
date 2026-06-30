-- ─── PROCEDURE→FUNCTION: vacation_updaterequestep ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_updaterequestep(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updaterequestep(
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_date timestamp without time zone,
    IN p_typea integer,
    IN p_td double precision,
    IN p_uno character varying,
    IN p_dno character varying,
    IN p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   TypeId := vacation_updaterequestep.p_type;
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
