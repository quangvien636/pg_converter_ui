-- ─── FUNCTION: gwwkyyempdays ───────────────────────────────
DROP FUNCTION IF EXISTS public.gwwkyyempdays(character varying);
CREATE OR REPLACE FUNCTION public.gwwkyyempdays(
    occuryy character varying
) RETURNS TABLE(
    occurdays text,
    absdays text,
    balancedays text,
    holidays text,
    otherdays text
)
AS $function$
BEGIN

		   RETURN QUERY
		   SELECT 0 as OccurDays, 0 as AbsDays, 0 as BalanceDays, 0 as Holidays, 0 as Otherdays;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
