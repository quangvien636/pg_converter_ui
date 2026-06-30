-- ─── FUNCTION: bslg_orglogyyyymod ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_orglogyyyymod(character varying, character varying, integer, text, text);
CREATE OR REPLACE FUNCTION public.bslg_orglogyyyymod(
    departid character varying,
    date character varying,
    userno integer,
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
   
 SELECT Chk = bslg_orglogyyyymod.departid FROM BSLG_OrgLogYYYY WHERE RegDate=bslg_orglogyyyymod.date AND DepartID=bslg_orglogyyyymod.departid  
  
 IF DepartID = Chk  
  BEGIN  ;
   UPDATE BSLG_OrgLogYYYY SET SLog=bslg_orglogyyyymod.scontent , ELog=bslg_orglogyyyymod.econtent  ,UserNo = bslg_orglogyyyymod.userno
   WHERE RegDate=bslg_orglogyyyymod.date AND DepartID=bslg_orglogyyyymod.departid  
  END  
 ELSE  
  BEGIN  ;
   INSERT INTO BSLG_OrgLogYYYY(DepartID, RegDate,UserNo, SLog,ELog)  
   VALUES(DepartID, Date,UserNo, SContent, EContent);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
