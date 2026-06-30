-- ─── FUNCTION: webservice_gcminsertregid ───────────────────────────────
DROP FUNCTION IF EXISTS public.webservice_gcminsertregid(character varying, integer);
CREATE OR REPLACE FUNCTION public.webservice_gcminsertregid(
    regid character varying,
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WebService_GCMRegistration WHERE PhoneToken=PhoneToken;
	INSERT INTO WebService_GCMRegistration(RegID,UserNo,PhoneToken,DateCreate,IsDeleted)
	VALUES(regId,UserNo,PhoneToken,NOW(),0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
