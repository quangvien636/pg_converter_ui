-- ─── FUNCTION: quicklink_getdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.quicklink_getdata(integer);
CREATE OR REPLACE FUNCTION public.quicklink_getdata(
    userno integer
) RETURNS SETOF record
-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	RETURN QUERY
	SELECT * FROM public."QuickLink"  WHERE (UserNo=quicklink_getdata.userno OR UserNo = 0) and IsActive = TRUE 
		ORDER BY OrderId ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
