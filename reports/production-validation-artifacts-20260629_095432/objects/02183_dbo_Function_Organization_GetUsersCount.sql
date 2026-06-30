-- ─── FUNCTION: organization_getuserscount ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getuserscount();
CREATE OR REPLACE FUNCTION public.organization_getuserscount(
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN

	
	RETURN QUERY
	select count(*) as Cnt from Organization_Users
	where Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
