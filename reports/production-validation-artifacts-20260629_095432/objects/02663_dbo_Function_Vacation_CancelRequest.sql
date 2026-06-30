-- ─── FUNCTION: vacation_cancelrequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_cancelrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_cancelrequest(
    p_rid integer
) RETURNS void
AS $function$
BEGIN

update  Vacation_Requests 
set StatusUser = 1
where Vacation_Requests.RequestId = vacation_cancelrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
