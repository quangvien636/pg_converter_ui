-- ─── PROCEDURE→FUNCTION: vacation_addallrequestep ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_addallrequestep(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addallrequestep(
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


INSERT INTO Vacation_RequestEps (TypeId, Fromd, Tod, Note,DateCreate, UserNo,  UsernoI, TimeDis)
SELECT p_type,p_from,p_to,p_Note,NOW(),CONVERT(VARCHAR(50),u.UserNo)+',', u.UserNo, p_td
FROM Organization_Users U;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
