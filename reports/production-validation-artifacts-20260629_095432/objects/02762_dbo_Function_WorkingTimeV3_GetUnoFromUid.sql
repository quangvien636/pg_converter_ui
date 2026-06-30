-- ─── FUNCTION: workingtimev3_getunofromuid ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getunofromuid();
CREATE OR REPLACE FUNCTION public.workingtimev3_getunofromuid(
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT 
		 U.UserNo

	FROM   Organization_Users U where u.UserID = p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
