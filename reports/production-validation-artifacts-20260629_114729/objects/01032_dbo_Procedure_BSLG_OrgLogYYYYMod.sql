-- ─── PROCEDURE→FUNCTION: bslg_orglogyyyymod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_orglogyyyymod(character varying, character varying, integer, text, text);
CREATE OR REPLACE FUNCTION public.bslg_orglogyyyymod(
    IN departid character varying,
    IN date character varying,
    IN userno integer,
    IN scontent text,
    IN econtent text
) RETURNS SETOF record
AS $function$
DECLARE
    chk character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
  

   
 SELECT DepartID INTO chk FROM BSLG_OrgLogYYYY WHERE RegDate=bslg_orglogyyyymod.date AND DepartID=bslg_orglogyyyymod.departid  
  
 IF DepartID = Chk THEN;
   UPDATE BSLG_OrgLogYYYY SET SLog=bslg_orglogyyyymod.scontent , ELog=bslg_orglogyyyymod.econtent  ,UserNo = bslg_orglogyyyymod.userno
   WHERE RegDate=bslg_orglogyyyymod.date AND DepartID=bslg_orglogyyyymod.departid  
  END IF;
 ELSE;
   INSERT INTO BSLG_OrgLogYYYY(DepartID, RegDate,UserNo, SLog,ELog)  
   VALUES(DepartID, Date,UserNo, SContent, EContent);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
