-- ─── FUNCTION: mail_pop3_readcheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_pop3_readcheck(character varying);
CREATE OR REPLACE FUNCTION public.mail_pop3_readcheck(
    domain character varying
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text
)
AS $function$
DECLARE
    cmsendnum bigint;
    address character varying;
BEGIN



	SELECT CMSendNum = CMSendNum
	FROM Mail_Mails WHERE IsSent = FALSE AND EmlFileName = Eml
	

	SET Address = PopID || '@' || Domain
	

	
	SELECT LogNo = LogNo, MailNo = MailNo, ReadDate = ReadDate
	FROM Mail_SentLogs WHERE CMSendNum = CMSendNum AND Address = Address

	UPDATE Mail_SentLogs SET DeliveredDate = Time
	WHERE LogNo = LogNo
		
	IF (ReadDate IS NULL) BEGIN
		
		UPDATE Mail_Mails SET ReadCount = ReadCount + 1
		WHERE MailNo = MailNo	
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
