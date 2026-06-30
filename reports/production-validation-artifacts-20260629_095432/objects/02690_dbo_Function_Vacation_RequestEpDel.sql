-- ─── FUNCTION: vacation_requestepdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_requestepdel(integer);
CREATE OR REPLACE FUNCTION public.vacation_requestepdel(
    p_no integer
) RETURNS void
AS $function$
BEGIN

				DELETE FROM Vacation_RequestEps 

				where RequestId = vacation_requestepdel.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
