-- ─── FUNCTION: bslg_spauthuserck ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_spauthuserck(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthuserck(
    userid character varying
) RETURNS TABLE(
    userid text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	RETURN QUERY
	SELECT UserID From BSLG_SpAuthInfo Where UserID=bslg_spauthuserck.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
