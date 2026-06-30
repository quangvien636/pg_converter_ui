-- ─── FUNCTION: mail_insertfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertfile(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.mail_insertfile(
    mailno bigint,
    name character varying,
    size integer
) RETURNS TABLE(
    fileno text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Mail_MailFiles
	VALUES (MailNo, Name, Size)
	

	SET FileNo = lastval()
	
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
