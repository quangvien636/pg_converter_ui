-- ─── PROCEDURE→FUNCTION: bslg_orglogmod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_orglogmod(character varying, character varying, text, text);
CREATE OR REPLACE FUNCTION public.bslg_orglogmod(
    IN departid character varying,
    IN date character varying,
    IN scontent text,
    IN econtent text
) RETURNS SETOF record
AS $function$
DECLARE
    chk character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
  

   
 SELECT DepartID INTO chk FROM BSLG_OrgLog WHERE RegDate=bslg_orglogmod.date AND DepartID=bslg_orglogmod.departid  
  
 IF DepartID = Chk THEN;
   UPDATE BSLG_OrgLog SET SLog=bslg_orglogmod.scontent , ELog=bslg_orglogmod.econtent  
   WHERE RegDate=bslg_orglogmod.date AND DepartID=bslg_orglogmod.departid  
  END IF;
 ELSE;
   INSERT INTO BSLG_OrgLog(DepartID, RegDate, SLog,ELog)  
   VALUES(DepartID, Date, SContent, EContent);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
