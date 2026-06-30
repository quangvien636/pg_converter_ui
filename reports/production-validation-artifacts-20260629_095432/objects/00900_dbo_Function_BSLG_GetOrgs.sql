-- ─── FUNCTION: bslg_getorgs ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getorgs(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getorgs(
    userid character varying,
    orgcd character varying,
    useyn character varying
) RETURNS TABLE(
    userid text,
    usernm text,
    orgcd text,
    posfg text,
    gradefg text
)
AS $function$
BEGIN

   
    RETURN QUERY
    select 
  UserId
 , CASE Lang   
   WHEN '1' THEN UserNm1   
   WHEN '2' THEN CASE UserNm2 WHEN '' THEN UserNm2 ELSE UserNm2 END  
   WHEN '3' THEN CASE UserNm3 WHEN '' THEN UserNm2 ELSE UserNm3 END  
   WHEN '4' THEN CASE UserNm4 WHEN '' THEN UserNm2 ELSE UserNm4 END  
   ELSE UserNm1  
   End AS UserNm  
 , OrgCd1   as OrgCd  
 , PosFg1   as PosFg  
 , GradeFg1  as GradeFg  
 from CMONUsers 
 where UseYn = 'Y' AND (
  OrgCd1 =bslg_getorgs.orgcd 
  OR OrgCd2 =bslg_getorgs.orgcd
  OR OrgCd3 =bslg_getorgs.orgcd 
  OR OrgCd4 =bslg_getorgs.orgcd 
  OR OrgCd5 =bslg_getorgs.orgcd 
  OR OrgCd6 =bslg_getorgs.orgcd
  OR OrgCd7 =bslg_getorgs.orgcd);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
