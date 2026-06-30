-- ─── FUNCTION: vacation_delrequestep ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_delrequestep(integer);
CREATE OR REPLACE FUNCTION public.vacation_delrequestep(
    p_no integer
) RETURNS void
AS $function$
BEGIN

				DELETE FROM Vacation_RequestEps 
				where UsernoI = vacation_delrequestep.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
