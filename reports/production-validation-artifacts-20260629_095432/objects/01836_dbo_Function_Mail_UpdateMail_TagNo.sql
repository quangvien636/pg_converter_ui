-- ─── FUNCTION: mail_updatemail_tagno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_tagno(bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemail_tagno(
    mailno bigint,
    tagno bigint
) RETURNS void
AS $function$
BEGIN



	
	SELECT
		UserNo = UserNo,
		IsSent = IsSent,
		_TagNo = mail_updatemail_tagno.tagno,
		ReadDate = ReadDate
	FROM Mail_Mails WHERE MailNo = mail_updatemail_tagno.mailno

	IF (TagNo = _TagNo) BEGIN

		RETURN

	END

	IF (TagNo = 0) BEGIN

		UPDATE Mail_Mails SET TagNo = 0 WHERE MailNo = mail_updatemail_tagno.mailno

		IF (ReadDate IS NULL) BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE TagNo = _TagNo

		END

		ELSE BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1 WHERE TagNo = _TagNo

		END

	END

	ELSE BEGIN

		UPDATE Mail_Mails SET TagNo = mail_updatemail_tagno.tagno WHERE MailNo = mail_updatemail_tagno.mailno

		IF (ReadDate IS NULL) BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE TagNo = _TagNo;
			UPDATE Mail_MailTags SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1 WHERE TagNo = mail_updatemail_tagno.tagno

		END

		ELSE BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1 WHERE TagNo = _TagNo;
			UPDATE Mail_MailTags SET TotalCount = TotalCount + 1 WHERE TagNo = mail_updatemail_tagno.tagno

		END

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
