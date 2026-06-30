-- ─── FUNCTION: quicklink_update ───────────────────────────────
DROP FUNCTION IF EXISTS public.quicklink_update(bigint, integer, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.quicklink_update(
    seq bigint,
    userno integer,
    title character varying,
    url character varying,
    orderid integer
) RETURNS SETOF record
-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	UPDATE public."QuickLink"
	SET Title = quicklink_update.title, 
		Url = quicklink_update.url
	WHERE UserNo=quicklink_update.userno and IsActive = TRUE
		AND Seq = quicklink_update.seq
			 

	RETURN QUERY
	SELECT * FROM public."QuickLink"  WHERE UserNo=quicklink_update.userno and IsActive = TRUE 
		ORDER BY OrderId ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
