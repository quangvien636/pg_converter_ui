-- ─── FUNCTION: noticesyn_getlistview ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getlistview(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.noticesyn_getlistview(
    noticeno integer,
    readdate timestamp without time zone
) RETURNS SETOF record
-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 RETURN QUERY
 SELECT * FROM public."NoticeSyn_Reference" 
 WHERE NoticeNo = noticesyn_getlistview.noticeno;
 -- and ReadDate=ReadDate
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
