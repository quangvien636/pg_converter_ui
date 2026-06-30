-- ─── FUNCTION: vacation_update ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_update(integer, double precision, timestamp without time zone, integer, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_update(
    p_uno integer,
    p_used double precision,
    p_date timestamp without time zone,
    p_years integer,
    p_vacations double precision DEFAULT 0,
    p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	update Vacation_Vacations

     set
		   Vacations =	vacation_update.p_vacations ,
		   Used =	vacation_update.p_used ,
		   Note=vacation_update.p_note ,
		   DateCreate =vacation_update.p_date  
		WHERE  UserNo = vacation_update.p_uno and years = vacation_update.p_years;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
