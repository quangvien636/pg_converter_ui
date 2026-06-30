-- ─── FUNCTION: mail_getsentlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsentlog(bigint);
CREATE OR REPLACE FUNCTION public.mail_getsentlog(
    logno bigint
) RETURNS TABLE(
    cmsendnum text,
    name text,
    address text,
    senttype text,
    iscomplete text,
    iscancel text,
    readdate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CMSendNum, Name, Address, SentType, IsComplete, IsCancel, ReadDate
	FROM Mail_SentLogs
	WHERE LogNo = mail_getsentlog.logno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
