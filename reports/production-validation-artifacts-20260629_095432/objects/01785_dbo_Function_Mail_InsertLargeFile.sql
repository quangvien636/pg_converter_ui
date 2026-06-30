-- ─── FUNCTION: mail_insertlargefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertlargefile(bigint, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertlargefile(
    mailno bigint,
    name character varying,
    size integer,
    expirationdate timestamp without time zone
) RETURNS TABLE(
    fileno text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Mail_MailLargeFiles
	VALUES (MailNo, Name, Size, ExpirationDate)
	

	SET FileNo = lastval()
	
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
