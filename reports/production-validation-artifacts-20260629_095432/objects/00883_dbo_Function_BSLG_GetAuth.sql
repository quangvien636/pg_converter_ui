-- ─── FUNCTION: bslg_getauth ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getauth();
CREATE OR REPLACE FUNCTION public.bslg_getauth(
) RETURNS TABLE(
    orgmgm text,
    usersmgm text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	RETURN QUERY
	SELECT	OrgMgm, UsersMgm 
	FROM	BSLG_AuthInfo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
