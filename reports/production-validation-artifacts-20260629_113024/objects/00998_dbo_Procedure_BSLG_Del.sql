-- ─── PROCEDURE→FUNCTION: bslg_del ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_del(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_del(
    IN userid character varying,
    IN date character varying,
    IN plot character varying,
    IN orgcd character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_Log 
	WHERE UserID = bslg_del.userid AND RegDate=bslg_del.date AND Plot = bslg_del.plot;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
