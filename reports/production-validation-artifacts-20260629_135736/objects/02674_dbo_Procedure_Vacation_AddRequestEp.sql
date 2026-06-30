-- ─── PROCEDURE→FUNCTION: vacation_addrequestep ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_addrequestep(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addrequestep(
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_date timestamp without time zone,
    IN p_typea integer,
    IN p_td double precision,
    IN p_uno character varying,
    IN p_dno character varying,
    IN p_note character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
END;


--SELECT * FROM Vacation_RequestEps
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
