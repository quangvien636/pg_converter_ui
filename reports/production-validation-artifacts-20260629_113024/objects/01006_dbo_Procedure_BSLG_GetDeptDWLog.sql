-- ─── PROCEDURE→FUNCTION: bslg_getdeptdwlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getdeptdwlog(character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdeptdwlog(
    IN userid character varying,
    IN sdate character varying,
    IN edate character varying,
    IN title character varying,
    IN content character varying,
    IN langindex character varying,
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	 IF Orgcd is null THEN
	   Orgcd := '';
	 RETURN QUERY
	 SELECT UserID,public."CmonGetUserNm"(UserID,langindex) as UserName,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title  
	 FROM BSLG_Log   
	 WHERE UserID=bslg_getdeptdwlog.userid AND (RegDate >= bslg_getdeptdwlog.sdate AND RegDate <=  bslg_getdeptdwlog.edate )   
	 AND     Title ILIKE '%' || Title || '%'  
	 AND     Content1 ILIKE '%' || Content || '%'   and OrgCd = bslg_getdeptdwlog.orgcd
	 ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
