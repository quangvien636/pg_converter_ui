-- ─── FUNCTION: webservice_getregid ───────────────────────────────
DROP FUNCTION IF EXISTS public.webservice_getregid(integer);
CREATE OR REPLACE FUNCTION public.webservice_getregid(
    userno integer
) RETURNS TABLE(
    regno serial,
    regid text,
    datecreate date,
    isdeleted integer,
    userno integer,
    phonetoken character varying(250),
    appkey character varying(50)
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM WebService_GCMRegistration
	WHERE UserNo=webservice_getregid.userno AND AppKey=AppKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
