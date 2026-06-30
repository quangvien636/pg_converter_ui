-- ─── FUNCTION: webservice_gcmgetlistregids ───────────────────────────────
DROP FUNCTION IF EXISTS public.webservice_gcmgetlistregids(integer);
CREATE OR REPLACE FUNCTION public.webservice_gcmgetlistregids(
    isdeleted integer
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
	WHERE isDeleted=webservice_gcmgetlistregids.isdeleted AND AppKey=AppKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
