-- ─── FUNCTION: vacation_updaterequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_updaterequest(integer, timestamp without time zone, timestamp without time zone, double precision, integer);
CREATE OR REPLACE FUNCTION public.vacation_updaterequest(
    p_id integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_vcount double precision,
    p_type integer
) RETURNS TABLE(
    p_id text
)
AS $function$
BEGIN

update  Vacation_Requests set
           Fromd = vacation_updaterequest.p_from
           ,Tod = vacation_updaterequest.p_to
		   ,VacationsCount = vacation_updaterequest.p_vcount
		   ,DateUpdate = NOW()
		   ,TypeId = vacation_updaterequest.p_type
		   where RequestId = vacation_updaterequest.p_id;
			RETURN QUERY
			select p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
