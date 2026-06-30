-- ─── FUNCTION: vacation_eappdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_eappdel(character varying, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.vacation_eappdel(
    userid character varying,
    code integer,
    fromdt character varying,
    todt character varying,
    use double precision
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
