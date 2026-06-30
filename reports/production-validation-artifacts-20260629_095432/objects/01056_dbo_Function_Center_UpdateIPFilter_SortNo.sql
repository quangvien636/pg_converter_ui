-- ─── FUNCTION: center_updateipfilter_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateipfilter_sortno(integer, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilter_sortno(
    filterno integer,
    isup boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
BEGIN



	SELECT SortNo = SortNo
	FROM Center_IPFilters WHERE FilterNo = center_updateipfilter_sortno.filterno
	
	IF (IsUp = TRUE) BEGIN
	
		IF (SortNo != 1) BEGIN
		
			UPDATE Center_IPFilters SET SortNo = SortNo + 1 WHERE SortNo = SortNo - 1;
			UPDATE Center_IPFilters SET SortNo = SortNo - 1 WHERE FilterNo = center_updateipfilter_sortno.filterno
			
		END
		
	END
	
	ELSE BEGIN
	
		UPDATE Center_IPFilters SET SortNo = SortNo - 1 WHERE SortNo = SortNo + 1;
		UPDATE Center_IPFilters SET SortNo = SortNo + 1 WHERE FilterNo = center_updateipfilter_sortno.filterno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
