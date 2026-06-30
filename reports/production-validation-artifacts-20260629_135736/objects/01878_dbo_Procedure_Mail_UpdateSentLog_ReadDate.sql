-- ─── PROCEDURE→FUNCTION: mail_updatesentlog_readdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_updatesentlog_readdate(bigint, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatesentlog_readdate(
    IN cmsendnum bigint,
    IN address character varying,
    IN isupdatecount boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	
	SELECT LogNo, MailNo, ReadDate INTO logno, mailno, readdate FROM Mail_SentLogs
	WHERE CMSendNum = mail_updatesentlog_readdate.cmsendnum AND (Address = mail_updatesentlog_readdate.address OR Address ILIKE '%<' || Address || '>%')

	IF ReadDate IS NULL THEN

		UPDATE Mail_SentLogs SET ReadDate = NOW()
		WHERE LogNo = LogNo
			
		IF DeliveredDate IS NULL THEN
					
			UPDATE Mail_Mails SET ReadCount = ReadCount + 1
			WHERE MailNo = MailNo AND RecipientsCount > ReadCount
		
		END IF;
			
		IF IsUpdateCount = TRUE THEN

			SELECT UserNo INTO userno FROM Mail_Accounts WHERE MailAddress = mail_updatesentlog_readdate.address
			
			SELECT MailNo INTO mailno FROM Mail_Mails
			WHERE UserNo = UserNo AND IsSent = FALSE AND CMSendNum = mail_updatesentlog_readdate.cmsendnum
			
			UPDATE Mail_Mails SET ReadDate = NOW()
			WHERE MailNo = MailNo
			
		END IF;
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
