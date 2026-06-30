-- ─── PROCEDURE→FUNCTION: bslg_spauthdel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_spauthdel(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthdel(
    IN userid character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_SpAuthInfo WHERE UserID=bslg_spauthdel.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
