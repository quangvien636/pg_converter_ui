-- ─── FUNCTION: bslg_orglogyyyydel ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_orglogyyyydel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_orglogyyyydel(
    departid character varying,
    date character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_OrgLogYYYY WHERE RegDate=bslg_orglogyyyydel.date AND DepartID=bslg_orglogyyyydel.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
