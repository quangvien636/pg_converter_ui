-- ─── FUNCTION: vacation_getrequestbyday ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getrequestbyday(character varying, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.vacation_getrequestbyday(
    p_uid character varying,
    p_from timestamp without time zone,
    p_to timestamp without time zone
) RETURNS TABLE(
    requestid serial,
    userno integer,
    typeid integer,
    fromd timestamp without time zone,
    tod timestamp without time zone,
    vacationscount double precision,
    note character varying(4000),
    datecreate timestamp without time zone,
    statususer integer,
    statusadmin integer,
    dateupdate timestamp without time zone
)
AS $function$
BEGIN



				RETURN QUERY
				SELECT 
					 *
				FROM  Vacation_Requests R
				WHERE R.UserNo = p_Uno 
					AND (
					( p_from < R.Fromd and R.Fromd  < vacation_getrequestbyday.p_to)
					or ( p_from < R.Tod and  R.Tod < vacation_getrequestbyday.p_to )
					or (R.Fromd = vacation_getrequestbyday.p_from  and  R.Tod = vacation_getrequestbyday.p_to )
					);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
