-- ─── PROCEDURE→FUNCTION: webservice_gcminsertregid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.webservice_gcminsertregid(character varying, integer);
CREATE OR REPLACE FUNCTION public.webservice_gcminsertregid(
    IN regid character varying,
    IN userno integer
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
