-- ─── PROCEDURE→FUNCTION: mail_updatemail_tagno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemail_tagno(bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemail_tagno(
    IN mailno bigint,
    IN tagno bigint
) RETURNS void
AS $function$
BEGIN



	
	SELECT UserNo, IsSent, TagNo INTO userno, issent, _tagno FROM Mail_Mails WHERE MailNo = mail_updatemail_tagno.mailno

	IF TagNo = _TagNo THEN

		RETURN

	END IF;

	IF TagNo = 0 THEN

		UPDATE Mail_Mails SET TagNo = 0 WHERE MailNo = mail_updatemail_tagno.mailno

		IF ReadDate IS NULL THEN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE TagNo = _TagNo

		END IF;

		ELSE BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1 WHERE TagNo = _TagNo

		END IF;

	END;

	ELSE BEGIN

		UPDATE Mail_Mails SET TagNo = mail_updatemail_tagno.tagno WHERE MailNo = mail_updatemail_tagno.mailno

		IF ReadDate IS NULL THEN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE TagNo = _TagNo;
			UPDATE Mail_MailTags SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1 WHERE TagNo = mail_updatemail_tagno.tagno

		END IF;

		ELSE BEGIN

			UPDATE Mail_MailTags SET TotalCount = TotalCount - 1 WHERE TagNo = _TagNo;
			UPDATE Mail_MailTags SET TotalCount = TotalCount + 1 WHERE TagNo = mail_updatemail_tagno.tagno

		END;

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
