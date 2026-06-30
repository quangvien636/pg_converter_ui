-- ─── PROCEDURE→FUNCTION: webservice_gcmupdateregid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.webservice_gcmupdateregid(character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.webservice_gcmupdateregid(
    IN regid character varying,
    IN userno integer,
    IN phonetoken character varying
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
