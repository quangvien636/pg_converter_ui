-- ─── FUNCTION: center_insertipfilterforapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertipfilterforapplication(integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertipfilterforapplication(
    applicationno integer,
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
	FROM Center_IPFiltersForApplication
	WHERE ApplicationNo = center_insertipfilterforapplication.applicationno
	
	INSERT INTO Center_IPFiltersForApplication (ApplicationNo, ClientIP, Allow, SortNo)
	VALUES (ApplicationNo, ClientIP, Allow, SortNo + 1)
	

	SET FilterNo = lastval()
	
	RETURN QUERY
	SELECT FilterNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
