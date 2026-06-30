-- ─── FUNCTION: center_getcrewchatnotificationuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getcrewchatnotificationuserlist();
CREATE OR REPLACE FUNCTION public.center_getcrewchatnotificationuserlist(
) RETURNS TABLE(
    userid text
)
AS $function$
BEGIN

	
	RETURN QUERY
	select UserID from Organization_Users where Enabled = TRUE and userid != '' and UserID != 'crewnotifer';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
