-- ─── FUNCTION: center_insertipfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertipfilter(character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertipfilter(
    clientip character varying,
    allow boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
    filterno integer;
BEGIN



	SELECT SortNo = COALESCE(MAX(SortNo), 0)
	FROM Center_IPFilters

	INSERT INTO Center_IPFilters (ClientIP, Allow, SortNo)
	VALUES (ClientIP, Allow, SortNo + 1)
	

	SET FilterNo = lastval()
	
	RETURN QUERY
	SELECT FilterNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
