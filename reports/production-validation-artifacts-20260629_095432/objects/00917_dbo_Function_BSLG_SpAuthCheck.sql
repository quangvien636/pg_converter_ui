-- ─── FUNCTION: bslg_spauthcheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_spauthcheck(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthcheck(
    userid character varying
) RETURNS TABLE(
    permissioncount text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	RETURN QUERY
	SELECT count(*) as Permissioncount From BSLG_SpAuthInfo Where UserID=bslg_spauthcheck.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
