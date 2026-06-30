-- ─── FUNCTION: dday_locationhost ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_locationhost();
CREATE OR REPLACE FUNCTION public.dday_locationhost(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN




	RETURN QUERY
	SELECT  'http://localhost:8082';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
