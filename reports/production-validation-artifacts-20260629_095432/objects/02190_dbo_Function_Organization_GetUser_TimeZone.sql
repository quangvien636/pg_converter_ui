-- ─── FUNCTION: organization_getuser_timezone ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getuser_timezone(integer);
CREATE OR REPLACE FUNCTION public.organization_getuser_timezone(
    userno integer
) RETURNS TABLE(
    timezone text
)
AS $function$
BEGIN

		
	RETURN QUERY
	SELECT TimeZone
	FROM Organization_Users
	WHERE UserNo = organization_getuser_timezone.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
