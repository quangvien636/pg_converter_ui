-- ─── PROCEDURE→FUNCTION: bslg_authreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_authreg(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_authreg(
    IN flag character varying,
    IN type character varying
) RETURNS void
AS $function$
BEGIN
   if not exists (select * from BSLG_AuthInfo)
   begin;
     insert into BSLG_AuthInfo(OrgMgm,UsersMgm) values('3','1')
   END;
	
   update BSLG_AuthInfo set OrgMgm = bslg_authreg.flag, UsersMgm = bslg_authreg.type;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
