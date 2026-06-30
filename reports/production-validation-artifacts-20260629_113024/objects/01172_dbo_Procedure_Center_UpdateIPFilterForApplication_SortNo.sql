-- ─── PROCEDURE→FUNCTION: center_updateipfilterforapplication_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateipfilterforapplication_sortno(integer, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilterforapplication_sortno(
    IN filterno integer,
    IN isup boolean
) RETURNS void
AS $function$
BEGIN



	SELECT ApplicationNo INTO applicationno FROM Center_IPFiltersForApplication WHERE FilterNo = center_updateipfilterforapplication_sortno.filterno
	
	IF IsUp = TRUE THEN
	
		IF SortNo != 1 THEN
		
			UPDATE Center_IPFiltersForApplication SET SortNo = SortNo + 1
			WHERE ApplicationNo = ApplicationNo AND SortNo = SortNo - 1
			
			UPDATE Center_IPFiltersForApplication SET SortNo = SortNo - 1
			WHERE ApplicationNo = ApplicationNo AND FilterNo = center_updateipfilterforapplication_sortno.filterno
			
		END IF;
		
	END IF;
	
	ELSE BEGIN
	
		UPDATE Center_IPFiltersForApplication SET SortNo = SortNo - 1
		WHERE ApplicationNo = ApplicationNo AND SortNo = SortNo + 1
		
		UPDATE Center_IPFiltersForApplication SET SortNo = SortNo + 1
		WHERE ApplicationNo = ApplicationNo AND FilterNo = center_updateipfilterforapplication_sortno.filterno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
