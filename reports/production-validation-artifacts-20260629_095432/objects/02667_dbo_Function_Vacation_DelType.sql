-- ─── FUNCTION: vacation_deltype ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_deltype(integer);
CREATE OR REPLACE FUNCTION public.vacation_deltype(
    p_id integer
) RETURNS void
AS $function$
BEGIN

DELETE FROM Vacation_Types
     WHERE TypeId = vacation_deltype.p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
