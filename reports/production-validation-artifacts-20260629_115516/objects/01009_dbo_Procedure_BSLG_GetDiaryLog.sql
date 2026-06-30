-- ─── PROCEDURE→FUNCTION: bslg_getdiarylog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getdiarylog(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdiarylog(
    IN userid character varying,
    IN startdate character varying,
    IN enddate character varying,
    IN searchtext character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5 
	FROM BSLG_Log WHERE UserID=bslg_getdiarylog.userid 
	AND Plot = 'Diary'
	AND  Content1 ILIKE '%' || SearchText || '%'
	AND ( RegDate >= bslg_getdiarylog.startdate AND RegDate <= bslg_getdiarylog.enddate) ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
