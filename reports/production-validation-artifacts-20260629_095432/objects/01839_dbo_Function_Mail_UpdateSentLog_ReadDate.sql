-- ─── FUNCTION: mail_updatesentlog_readdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatesentlog_readdate(bigint, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatesentlog_readdate(
    cmsendnum bigint,
    address character varying,
    isupdatecount boolean DEFAULT FALSE
) RETURNS TABLE(
    col1 text,
    col2 text
)
AS $function$
BEGIN



	
	SELECT LogNo = LogNo, MailNo = MailNo, ReadDate = ReadDate, DeliveredDate = DeliveredDate
	FROM Mail_SentLogs
	WHERE CMSendNum = mail_updatesentlog_readdate.cmsendnum AND (Address = mail_updatesentlog_readdate.address OR Address ILIKE '%<' || Address || '>%')

	IF (ReadDate IS NULL) BEGIN

		UPDATE Mail_SentLogs SET ReadDate = NOW()
		WHERE LogNo = LogNo
			
		IF (DeliveredDate IS NULL) BEGIN
					
			UPDATE Mail_Mails SET ReadCount = ReadCount + 1
			WHERE MailNo = MailNo AND RecipientsCount > ReadCount
		
		END
			
		IF (IsUpdateCount = TRUE) BEGIN

			SELECT UserNo = UserNo FROM Mail_Accounts WHERE MailAddress = mail_updatesentlog_readdate.address
			
			SELECT MailNo = MailNo, BoxNo = BoxNo
			FROM Mail_Mails
			WHERE UserNo = UserNo AND IsSent = FALSE AND CMSendNum = mail_updatesentlog_readdate.cmsendnum
			
			UPDATE Mail_Mails SET ReadDate = NOW()
			WHERE MailNo = MailNo
			
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
