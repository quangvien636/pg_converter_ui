-- ─── FUNCTION: organization_get_scalar_useraddfields ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_get_scalar_useraddfields(integer);
CREATE OR REPLACE FUNCTION public.organization_get_scalar_useraddfields(
    userno integer
) RETURNS TABLE(
    value text
)
AS $function$
BEGIN


		RETURN QUERY
		select Value from Organization_Users_Addfields 
		where UserNo = organization_get_scalar_useraddfields.userno
		and Key = Key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
