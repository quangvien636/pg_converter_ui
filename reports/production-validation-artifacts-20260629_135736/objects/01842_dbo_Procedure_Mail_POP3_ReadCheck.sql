-- ─── PROCEDURE→FUNCTION: mail_pop3_readcheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_pop3_readcheck(character varying);
CREATE OR REPLACE FUNCTION public.mail_pop3_readcheck(
    IN domain character varying
) RETURNS SETOF record
AS $function$
DECLARE
    cmsendnum bigint;
    address character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM Mail_Mails WHERE IsSent = FALSE AND EmlFileName = Eml
	

	Address := PopID || '@' || Domain;

	
	SELECT LogNo, MailNo INTO logno, mailno FROM Mail_SentLogs WHERE CMSendNum = CMSendNum AND Address = Address

	UPDATE Mail_SentLogs SET DeliveredDate = Time
	WHERE LogNo = LogNo
		
	IF ReadDate IS NULL THEN
		
		UPDATE Mail_Mails SET ReadCount = ReadCount + 1
		WHERE MailNo = MailNo	
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
