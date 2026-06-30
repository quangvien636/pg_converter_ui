-- ─── FUNCTION: vacation_addrequestep ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_addrequestep(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addrequestep(
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_date timestamp without time zone,
    p_typea integer,
    p_td double precision,
    p_uno character varying,
    p_dno character varying,
    p_note character varying DEFAULT ''
) RETURNS TABLE(
    requestid serial,
    typeid integer,
    fromd timestamp without time zone,
    tod timestamp without time zone,
    note character varying(4000),
    datecreate timestamp without time zone,
    statususer integer,
    statusadmin integer,
    typeforall integer,
    timedis double precision,
    userno character varying(500),
    departno character varying(500),
    usernoi integer,
    vacationscount integer
)
AS $function$
BEGIN

		-----INSERT INTO if null;
		INSERT INTO Vacation_RequestEps (TypeId, Fromd, Tod, Note,DateCreate, Userno, UsernoI, TimeDis)
		RETURN QUERY
		SELECT p_type,p_from,p_to,p_Note,NOW(),CONVERT(VARCHAR(50),u.UserNo)+',', u.UserNo, p_td
		FROM Organization_Users U
		WHERE    (',' || p_Uno || ',' ILIKE '%,' || CONVERT(VARCHAR(50),u.UserNo)+',%' )
						or 
						EXISTS (select d.* from Organization_BelongToDepartment  B  
								INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
								where B.UserNo = u.UserNo
								and  ',' || p_Dno || ',' ILIKE '%,' || CONVERT(VARCHAR(50),d.DepartNo)+',%');
end;


--SELECT * FROM Vacation_RequestEps
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
