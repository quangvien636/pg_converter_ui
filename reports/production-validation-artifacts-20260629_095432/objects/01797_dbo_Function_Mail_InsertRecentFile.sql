-- ─── FUNCTION: mail_insertrecentfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertrecentfile(integer, bigint, bigint, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_insertrecentfile(
    userno integer,
    mailno bigint,
    fileno bigint,
    name character varying,
    size integer,
    actiondate timestamp without time zone
) RETURNS TABLE(
    recentno text
)
AS $function$
DECLARE
    recentno bigint;
BEGIN


	DELETE FROM Mail_RecentMailFiles WHERE FileNo = mail_insertrecentfile.fileno

	INSERT INTO Mail_RecentMailFiles (UserNo, MailNo, FileNo, Name, Size, ActionDate)
	VALUES (UserNo, MailNo, FileNo, Name, Size, ActionDate)
	

	SET RecentNo = lastval()
	
	RETURN QUERY
	SELECT RecentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
