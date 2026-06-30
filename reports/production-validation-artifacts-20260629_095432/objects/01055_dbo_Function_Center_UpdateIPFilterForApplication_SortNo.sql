-- ─── FUNCTION: center_updateipfilterforapplication_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateipfilterforapplication_sortno(integer, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilterforapplication_sortno(
    filterno integer,
    isup boolean
) RETURNS void
AS $function$
BEGIN



	SELECT ApplicationNo = ApplicationNo, SortNo = SortNo
	FROM Center_IPFiltersForApplication WHERE FilterNo = center_updateipfilterforapplication_sortno.filterno
	
	IF (IsUp = TRUE) BEGIN
	
		IF (SortNo != 1) BEGIN
		
			UPDATE Center_IPFiltersForApplication SET SortNo = SortNo + 1
			WHERE ApplicationNo = ApplicationNo AND SortNo = SortNo - 1
			
			UPDATE Center_IPFiltersForApplication SET SortNo = SortNo - 1
			WHERE ApplicationNo = ApplicationNo AND FilterNo = center_updateipfilterforapplication_sortno.filterno
			
		END
		
	END
	
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
