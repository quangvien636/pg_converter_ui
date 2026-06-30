-- ─── FUNCTION: mail_getrecentfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getrecentfiles(integer);
CREATE OR REPLACE FUNCTION public.mail_getrecentfiles(
    userno integer
) RETURNS TABLE(
    recentno text,
    userno text,
    mailno text,
    fileno text,
    name text,
    size text,
    actiondate text,
    mailtitle text
)
AS $function$
DECLARE
    recentno bigint;
BEGIN


	IF ((SELECT COUNT(*) FROM Mail_RecentMailFiles WHERE UserNo = mail_getrecentfiles.userno) = 30) BEGIN
	

		SELECT RecentNo = MIN(RecentNo) FROM Mail_RecentMailFiles WHERE UserNo = mail_getrecentfiles.userno
		
		DELETE FROM Mail_RecentMailFiles WHERE RecentNo = RecentNo
	
	END

	RETURN QUERY
	SELECT F.RecentNo, F.UserNo, F.MailNo, F.FileNo, F.Name, F.Size, F.ActionDate,
		M.Title AS MailTitle
	FROM Mail_RecentMailFiles F
	INNER JOIN Mail_Mails M ON M.MailNo = F.MailNo
	WHERE F.UserNo = mail_getrecentfiles.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
