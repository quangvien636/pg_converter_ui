-- ─── PROCEDURE→FUNCTION: mail_insertmailsign ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertmailsign(integer, bigint, character varying);
CREATE OR REPLACE FUNCTION public.mail_insertmailsign(
    IN userno integer,
    IN accno bigint,
    IN name character varying
) RETURNS SETOF record
AS $function$
DECLARE
    signno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Mail_MailSigns WHERE UserNo = mail_insertmailsign.userno AND AccNo = mail_insertmailsign.accno) <> 0 THEN
	
		INSERT INTO Mail_MailSigns VALUES(UserNo, AccNo, Name, Content, 0)
    
    END IF;
    
    ELSE BEGIN
    
		INSERT INTO Mail_MailSigns VALUES(UserNo, AccNo, Name, Content, 1)
		
    END;
    

    SignNo := lastval();
    RETURN QUERY
    SELECT SignNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
