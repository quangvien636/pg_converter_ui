-- ─── FUNCTION: center_getipfilters ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getipfilters();
CREATE OR REPLACE FUNCTION public.center_getipfilters(
) RETURNS TABLE(
    filterno text,
    clientip text,
    allow text,
    sortno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FilterNo, ClientIP, Allow, SortNo
	FROM Center_IPFilters
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
