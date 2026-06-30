-- ─── FUNCTION: mail_insertsentlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertsentlog(bigint, bigint, character varying, character varying, integer, boolean, boolean, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertsentlog(
    mailno bigint,
    cmsendnum bigint,
    name character varying,
    address character varying,
    senttype integer,
    iscomplete boolean,
    iscancel boolean,
    readdate timestamp without time zone
) RETURNS TABLE(
    fileno text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Mail_SentLogs (MailNo, CMSendNum, Name, Address, SentType, IsComplete, IsCancel, ReadDate)
	VALUES (MailNo, CMSendNum, Name, Address, SentType, IsComplete, IsCancel, ReadDate)


	SET FileNo = lastval()
	
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
