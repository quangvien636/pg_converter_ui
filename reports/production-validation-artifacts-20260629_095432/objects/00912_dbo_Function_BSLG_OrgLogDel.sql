-- ─── FUNCTION: bslg_orglogdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_orglogdel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_orglogdel(
    departid character varying,
    date character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_OrgLog WHERE RegDate=bslg_orglogdel.date AND DepartID=bslg_orglogdel.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
