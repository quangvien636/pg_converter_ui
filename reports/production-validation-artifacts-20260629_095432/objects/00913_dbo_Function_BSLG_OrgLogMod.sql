-- ─── FUNCTION: bslg_orglogmod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_orglogmod(character varying, character varying, text, text);
CREATE OR REPLACE FUNCTION public.bslg_orglogmod(
    departid character varying,
    date character varying,
    scontent text,
    econtent text
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    chk character varying;
BEGIN
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
 SELECT Chk = bslg_orglogmod.departid FROM BSLG_OrgLog WHERE RegDate=bslg_orglogmod.date AND DepartID=bslg_orglogmod.departid  
  
 IF DepartID = Chk  
  BEGIN  ;
   UPDATE BSLG_OrgLog SET SLog=bslg_orglogmod.scontent , ELog=bslg_orglogmod.econtent  
   WHERE RegDate=bslg_orglogmod.date AND DepartID=bslg_orglogmod.departid  
  END  
 ELSE  
  BEGIN  ;
   INSERT INTO BSLG_OrgLog(DepartID, RegDate, SLog,ELog)  
   VALUES(DepartID, Date, SContent, EContent);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
