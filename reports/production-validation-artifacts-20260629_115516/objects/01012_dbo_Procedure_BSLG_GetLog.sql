-- ─── PROCEDURE→FUNCTION: bslg_getlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getlog(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getlog(
    IN userid character varying,
    IN startdate character varying,
    IN enddate character varying,
    IN searchtext character varying,
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Orgcd is null or Orgcd = '' or Orgcd = '*' THEN
		RETURN QUERY
		SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
		FROM BSLG_Log WHERE UserID=bslg_getlog.userid 
		AND (Plot = '' or Plot is null)
		AND  Content1 ILIKE '%' || SearchText || '%'
		AND ( RegDate >= bslg_getlog.startdate AND RegDate <= bslg_getlog.enddate) 
		--ANd Orgcd = Orgcd
		ORDER BY RegDate 
	END IF;
	ELSE
		RETURN QUERY
		SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
		FROM BSLG_Log WHERE UserID=bslg_getlog.userid 
		AND (Plot = '' or Plot is null)
		AND  Content1 ILIKE '%' || SearchText || '%'
		AND ( RegDate >= bslg_getlog.startdate AND RegDate <= bslg_getlog.enddate) 
		ANd Orgcd = bslg_getlog.orgcd
		ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
