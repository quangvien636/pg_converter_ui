-- ─── FUNCTION: vacation_aplyrequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_aplyrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_aplyrequest(
    p_rid integer
) RETURNS void
AS $function$
BEGIN

update  Vacation_Requests 
set StatusAdmin = 2
where Vacation_Requests.RequestId = vacation_aplyrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
