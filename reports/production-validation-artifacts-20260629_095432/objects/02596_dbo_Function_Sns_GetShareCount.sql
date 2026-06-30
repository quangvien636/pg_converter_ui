-- ─── FUNCTION: sns_getsharecount ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getsharecount(integer);
CREATE OR REPLACE FUNCTION public.sns_getsharecount(
    messageno integer
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN



	RETURN QUERY
	SELECT COUNT(*) AS CNT
	FROM SnsMessages AS M
	WHERE IsShare = TRUE AND ShareContentNo=sns_getsharecount.messageno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
