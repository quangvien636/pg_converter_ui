-- ─── FUNCTION: mail_insertmailsign ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailsign(integer, bigint, character varying);
CREATE OR REPLACE FUNCTION public.mail_insertmailsign(
    userno integer,
    accno bigint,
    name character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    signno bigint;
BEGIN


	IF (SELECT COUNT(*) FROM Mail_MailSigns WHERE UserNo = mail_insertmailsign.userno AND AccNo = mail_insertmailsign.accno) <> 0 BEGIN
	
		INSERT INTO Mail_MailSigns VALUES(UserNo, AccNo, Name, Content, 0)
    
    END
    
    ELSE BEGIN
    
		INSERT INTO Mail_MailSigns VALUES(UserNo, AccNo, Name, Content, 1)
		
    END
    

    SET SignNo = lastval()
    
    RETURN QUERY
    SELECT SignNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
