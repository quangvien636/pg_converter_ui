-- ─── FUNCTION: trademark_article_getcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.trademark_article_getcount();
CREATE OR REPLACE FUNCTION public.trademark_article_getcount(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
RETURN QUERY
SELECT COUNT(*) FROM public."TradeMark_Article";
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
