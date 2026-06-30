-- ─── FUNCTION: center_deleteipfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteipfilter(integer);
CREATE OR REPLACE FUNCTION public.center_deleteipfilter(
    filterno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
BEGIN



	SELECT SortNo = SortNo FROM Center_IPFilters WHERE FilterNo = center_deleteipfilter.filterno

	DELETE FROM Center_IPFilters WHERE FilterNo = center_deleteipfilter.filterno
	
	UPDATE Center_IPFilters SET SortNo = SortNo - 1
	WHERE SortNo > SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
