-- ─── FUNCTION: vacation_addallrequestep ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_addallrequestep(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addallrequestep(
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


INSERT INTO Vacation_RequestEps (TypeId, Fromd, Tod, Note,DateCreate, UserNo,  UsernoI, TimeDis)
SELECT p_type,p_from,p_to,p_Note,NOW(),CONVERT(VARCHAR(50),u.UserNo)+',', u.UserNo, p_td
FROM Organization_Users U;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
