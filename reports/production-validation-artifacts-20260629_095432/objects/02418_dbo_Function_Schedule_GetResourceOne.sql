-- ─── FUNCTION: schedule_getresourceone ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceone(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourceone(
    resourceno integer
) RETURNS TABLE(
    categoryno text,
    categoryname text,
    resourceno text,
    name text,
    enabled text,
    description text,
    buygroupno text,
    isreservation text,
    type text,
    col10 text,
    col11 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		R.CategoryNo,
		C.Name AS CategoryName,
		R.ResourceNo,
		R.Name,
		R.Enabled,
		R.Description,
		R.BuyGroupNo,
		R.IsReservation,
		R.Type
		,COALESCE(r.IsHidenReg,0) IsHidenReg
		,COALESCE(r.Color,'') Color
	FROM
		ScheduleResources r
		LEFT JOIN ScheduleResourceCategories c ON r.CategoryNo = c.CategoryNo
	WHERE ResourceNo = schedule_getresourceone.resourceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
