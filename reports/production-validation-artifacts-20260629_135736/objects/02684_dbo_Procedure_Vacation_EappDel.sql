-- ─── PROCEDURE→FUNCTION: vacation_eappdel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_eappdel(character varying, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.vacation_eappdel(
    IN userid character varying,
    IN code integer,
    IN fromdt character varying,
    IN todt character varying,
    IN use double precision
) RETURNS void
AS $function$
BEGIN


		delete from Vacation_Requests 
		where UserNo=p_uNo
		and typeId = vacation_eappdel.code
		and VacationsCount = vacation_eappdel.use
	    and Fromd = CONVERT(datetime,FromDt) and Tod=CONVERT(datetime,ToDt);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
