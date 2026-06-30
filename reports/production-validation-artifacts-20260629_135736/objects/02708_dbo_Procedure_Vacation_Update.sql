-- ─── PROCEDURE→FUNCTION: vacation_update ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_update(integer, double precision, timestamp without time zone, integer, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_update(
    IN p_uno integer,
    IN p_used double precision,
    IN p_date timestamp without time zone,
    IN p_years integer,
    IN p_vacations double precision DEFAULT 0,
    IN p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	update Vacation_Vacations

     Vacations := vacation_update.p_vacations ,;
		   Used =	vacation_update.p_used ,
		   Note=vacation_update.p_note ,
		   DateCreate =vacation_update.p_date  
		WHERE  UserNo = vacation_update.p_uno and years = vacation_update.p_years;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
