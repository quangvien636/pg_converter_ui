-- ─── PROCEDURE→FUNCTION: center_updateipfilter_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_updateipfilter_sortno(integer, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilter_sortno(
    IN filterno integer,
    IN isup boolean
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM Center_IPFilters WHERE FilterNo = center_updateipfilter_sortno.filterno
	
	IF IsUp = TRUE THEN
	
		IF SortNo != 1 THEN
		
			UPDATE Center_IPFilters SET SortNo = SortNo + 1 WHERE SortNo = SortNo - 1;
			UPDATE Center_IPFilters SET SortNo = SortNo - 1 WHERE FilterNo = center_updateipfilter_sortno.filterno
			
		END IF;
		
	END IF;
	
	ELSE BEGIN
	
		UPDATE Center_IPFilters SET SortNo = SortNo - 1 WHERE SortNo = SortNo + 1;
		UPDATE Center_IPFilters SET SortNo = SortNo + 1 WHERE FilterNo = center_updateipfilter_sortno.filterno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
