-- ─── FUNCTION: center_getipfiltersforapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getipfiltersforapplication(integer);
CREATE OR REPLACE FUNCTION public.center_getipfiltersforapplication(
    applicationno integer
) RETURNS TABLE(
    filterno text,
    applicationno text,
    clientip text,
    allow text,
    sortno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FilterNo, ApplicationNo, ClientIP, Allow, SortNo
	FROM Center_IPFiltersForApplication
	WHERE ApplicationNo = center_getipfiltersforapplication.applicationno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
