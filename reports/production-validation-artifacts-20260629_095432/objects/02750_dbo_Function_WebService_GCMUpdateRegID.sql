-- ─── FUNCTION: webservice_gcmupdateregid ───────────────────────────────
DROP FUNCTION IF EXISTS public.webservice_gcmupdateregid(character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.webservice_gcmupdateregid(
    regid character varying,
    userno integer,
    phonetoken character varying
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WebService_GCMRegistration WHERE PhoneToken=webservice_gcmupdateregid.phonetoken AND AppKey=AppKey;
	INSERT INTO WebService_GCMRegistration(RegID,UserNo,PhoneToken ,AppKey,DateCreate,IsDeleted)
	VALUES(regId,UserNo,PhoneToken,AppKey,NOW(),0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
