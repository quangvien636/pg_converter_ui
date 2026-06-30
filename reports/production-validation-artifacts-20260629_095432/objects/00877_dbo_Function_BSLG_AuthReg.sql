-- ─── FUNCTION: bslg_authreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_authreg(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_authreg(
    flag character varying,
    type character varying
) RETURNS void
AS $function$
BEGIN
   if not exists (select * from BSLG_AuthInfo)
   begin;
     insert into BSLG_AuthInfo(OrgMgm,UsersMgm) values('3','1')
   end 
	
   update BSLG_AuthInfo set OrgMgm = bslg_authreg.flag, UsersMgm = bslg_authreg.type;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
