-- ─── PROCEDURE→FUNCTION: mail_deletemailtag ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailtag(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailtag(
    IN tagno bigint
) RETURNS void
AS $function$
DECLARE
    userno integer;
BEGIN



	UserNo := (SELECT UserNo FROM Mail_MailTags WHERE TagNo = mail_deletemailtag.tagno);
	IF UserNo IS NOT NULL THEN

		DELETE FROM Mail_MailTags WHERE TagNo = mail_deletemailtag.tagno;
		UPDATE Mail_Mails SET TagNo = 0 WHERE UserNo = UserNo AND TagNo = mail_deletemailtag.tagno
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
