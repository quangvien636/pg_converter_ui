-- ─── FUNCTION: bslg_getcmonorgan ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getcmonorgan();
CREATE OR REPLACE FUNCTION public.bslg_getcmonorgan(
) RETURNS TABLE(
    orgcd text,
    parentorgcd text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT OrgCd , ParentOrgCd FROM cmonorgan
	WHERE UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
