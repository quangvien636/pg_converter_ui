-- ─── FUNCTION: vacation_delrequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_delrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_delrequest(
    p_rid integer
) RETURNS void
AS $function$
BEGIN

delete from Vacation_Requests  where Vacation_Requests.RequestId = vacation_delrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
