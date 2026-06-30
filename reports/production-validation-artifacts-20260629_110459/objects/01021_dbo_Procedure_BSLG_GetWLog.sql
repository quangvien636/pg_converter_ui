-- ─── PROCEDURE→FUNCTION: bslg_getwlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getwlog(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getwlog(
    IN userid character varying,
    IN startdate character varying,
    IN enddate character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT UserID,RegDate,Content, att1, att2, att3, att4, att5

	FROM BSLG_WLog 

	WHERE UserID=bslg_getwlog.userid AND ( RegDate >= bslg_getwlog.startdate AND RegDate <= bslg_getwlog.enddate ) 

	ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
