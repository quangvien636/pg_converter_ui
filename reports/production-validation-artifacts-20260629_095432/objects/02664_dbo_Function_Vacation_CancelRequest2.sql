-- ─── FUNCTION: vacation_cancelrequest2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_cancelrequest2(integer);
CREATE OR REPLACE FUNCTION public.vacation_cancelrequest2(
    p_rid integer
) RETURNS void
AS $function$
BEGIN

update  Vacation_Requests 
set StatusAdmin = 1
where Vacation_Requests.RequestId = vacation_cancelrequest2.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
