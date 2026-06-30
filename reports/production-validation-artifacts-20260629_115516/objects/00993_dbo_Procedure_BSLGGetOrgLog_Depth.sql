-- ─── PROCEDURE→FUNCTION: bslggetorglog_depth ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslggetorglog_depth(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslggetorglog_depth(
    IN departid character varying,
    IN date character varying,
    IN isdepth character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	

	
	IF IsDepth = '' or SUBSTRING(DepartID,1,1) = 'G' THEN
	RETURN QUERY
	SELECT DepartID, RegDate, SLog, ELog, att1, att2, att3, att4, att5, 
	 (select orgnm1 from CMONOrgan where OrgCd = bslggetorglog_depth.departid) as departname
	FROM BSLGOrgLog WHERE RegDate=bslggetorglog_depth.date AND DepartID=bslggetorglog_depth.departid
	
	 END IF;
	ELSE
	/*
 RETURN QUERY
 SELECT DepartID, RegDate, SLog, ELog, att1, att2, att3, att4, att5 ,
    (select orgnm1 from CMONOrgan where OrgCd = bslggetorglog_depth.departid) as departname
   FROM BSLGOrgLog WHERE RegDate=bslggetorglog_depth.date AND DepartID in (
  select OrgCd  from public."COMNGetOrganChild2"(DepartID)
  ) */
  
 RETURN QUERY
 SELECT DepartID, RegDate, SLog, ELog, att1, att2, att3, att4, att5 ,
    (select orgnm1 from CMONOrgan where OrgCd = bslggetorglog_depth.departid) as departname
   FROM BSLGOrgLog a, public."COMNGetOrganChild2"(DepartID) b WHERE RegDate=bslggetorglog_depth.date
   and a.Departid = b.orgcd  order by b.level;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
