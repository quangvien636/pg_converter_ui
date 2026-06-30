-- ─── FUNCTION: center_deleteipfilterforapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteipfilterforapplication(integer);
CREATE OR REPLACE FUNCTION public.center_deleteipfilterforapplication(
    filterno integer
) RETURNS void
AS $function$
BEGIN



	SELECT ApplicationNo = ApplicationNo, SortNo = SortNo
	FROM Center_IPFiltersForApplication WHERE FilterNo = center_deleteipfilterforapplication.filterno

	DELETE FROM Center_IPFiltersForApplication WHERE FilterNo = center_deleteipfilterforapplication.filterno
	
	UPDATE Center_IPFiltersForApplication SET SortNo = SortNo - 1
	WHERE ApplicationNo = ApplicationNo AND SortNo > SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
