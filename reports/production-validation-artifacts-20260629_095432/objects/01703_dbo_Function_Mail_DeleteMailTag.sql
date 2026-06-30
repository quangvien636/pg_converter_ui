-- ─── FUNCTION: mail_deletemailtag ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailtag(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailtag(
    tagno bigint
) RETURNS void
AS $function$
DECLARE
    userno integer;
BEGIN



	SET UserNo = (SELECT UserNo FROM Mail_MailTags WHERE TagNo = mail_deletemailtag.tagno)

	IF (UserNo IS NOT NULL) BEGIN

		DELETE FROM Mail_MailTags WHERE TagNo = mail_deletemailtag.tagno;
		UPDATE Mail_Mails SET TagNo = 0 WHERE UserNo = UserNo AND TagNo = mail_deletemailtag.tagno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
