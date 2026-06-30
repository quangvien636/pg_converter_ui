-- ─── PROCEDURE→FUNCTION: bslg_getdlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getdlog(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdlog(
    IN userid character varying,
    IN date character varying,
    IN plot character varying,
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	IF Orgcd is null THEN
	 Orgcd := '';
	IF Plot is null or Plot = '' THEN
		IF Orgcd is null or Orgcd = '' THEN
			RETURN QUERY
			SELECT	UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM 	BSLG_Log 
			WHERE 	UserID=bslg_getdlog.userid AND RegDate = bslg_getdlog.date AND Plot = bslg_getdlog.plot
		END IF;
		ELSE
			RETURN QUERY
			SELECT	UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM 	BSLG_Log 
			WHERE 	UserID=bslg_getdlog.userid AND RegDate = bslg_getdlog.date AND OrgCd =bslg_getdlog.orgcd
		END IF;
	ELSE
		RETURN QUERY
		SELECT	UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
		FROM 	BSLG_Log 
		WHERE 	UserID=bslg_getdlog.userid AND RegDate = bslg_getdlog.date AND Plot = bslg_getdlog.plot and OrgCd =bslg_getdlog.orgcd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
