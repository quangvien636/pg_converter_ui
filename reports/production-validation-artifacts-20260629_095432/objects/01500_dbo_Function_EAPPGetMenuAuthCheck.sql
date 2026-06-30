-- ─── FUNCTION: eappgetmenuauthcheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetmenuauthcheck(character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappgetmenuauthcheck(
    userid character varying,
    auth character varying
) RETURNS character varying
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    authfg character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


   -- 개인

    if (AuthFg is not null )  
    begin 
          return AuthFg
    end
     --공용그룹
   	set AuthFg=null
    select /* TOP 1 */ AuthFg=AuthFg from
     ( select AuthFg from CMONAuthGroup where AuthGrpFg=eappgetmenuauthcheck.auth  AND  UserGrpCd 
      in ( select  UserGrpCd from CMONUserGroupSet where UserId=eappgetmenuauthcheck.userid  )
     ) a  order by AuthFg desc
  
    if (AuthFg is not null )  
    begin 
          return AuthFg
    end

 --소속부서   
    set AuthFg=null
    select AuthFg=AuthFg from CMONAuthOrgan where AuthGrpFg=eappgetmenuauthcheck.auth  AND  OrgCd=OrgCd 
    if (AuthFg is not null )  
    begin 
          return AuthFg
    end
  --상위부서
  --  DECLARE OrgPath varchar(50)
  --  select OrgPath=OrgPath from CMONOrgan where OrgCd=OrgCd
    
  -- 	set AuthFg=null
  --  select /* TOP 1 */ AuthFg=AuthFg  from
  --   ( select AuthFg,pl  from CMONAuthOrgan a join 
  --     (select LEFT(OrgPath,4) OrgCd,4 pl union all 
  --      select  OrgCd,len(OrgPath) pl from CMONOrgan where  OrgPath  ILIKE  '%' || OrgPath || '%' and OrgCd<>OrgCd ) b
  --      on a.OrgCd=b.OrgCd
  --     where AuthGrpFg=Auth and lowYn='Y' ) c
		--order by pl desc,AuthFg desc 
		
    if (AuthFg is not null )  
    begin 
          return AuthFg
    end
    
   return '';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
