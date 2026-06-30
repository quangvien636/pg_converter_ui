-- ─── FUNCTION: mail_cleanupcountofmailboxs ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_cleanupcountofmailboxs();
CREATE OR REPLACE FUNCTION public.mail_cleanupcountofmailboxs(
) RETURNS void
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
BEGIN

	

		Index		BIGINT PRIMARY KEY IDENTITY(1, 1),
		UserNo		BIGINT
	)

	INSERT INTO ListOfUsers
	SELECT UserNo FROM Organization_Users WHERE Enabled = TRUE

	-------------------------------------------------------------------------------------------




	SET Index = 1
	SET TotalCount = (SELECT COUNT(*) FROM ListOfUsers)

	WHILE (Index <= TotalCount) BEGIN

		DELETE FROM AllBoxs
		SET UserNo = (SELECT UserNo FROM ListOfUsers WHERE Index = Index)

		-----------------------------------------------------------------------------------------

		INSERT INTO AllBoxs
		SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)

		UPDATE Mail_MailBoxs SET
			TotalCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo = Mail_MailBoxs.BoxNo AND IsDelete = FALSE),
			UnReadCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo = Mail_MailBoxs.BoxNo AND IsDelete = FALSE AND ReadDate IS NULL)
		WHERE Mail_MailBoxs.UserNo = UserNo

		UPDATE Mail_MailBoxs SET 
			TotalCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo IN (SELECT BoxNo FROM AllBoxs) AND IsDelete = FALSE),
			UnReadCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo IN (SELECT BoxNo FROM AllBoxs) AND IsDelete = FALSE AND ReadDate IS NULL)
		WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = UserNo AND ParentNo = -1 AND SortNo = 1)

		UPDATE Mail_MailTags SET
			TotalCount = (SELECT COUNT(*) FROM Mail_Mails WHERE TagNo = Mail_MailTags.TagNo AND IsDelete = FALSE),
			UnReadCount = (SELECT COUNT(*) FROM Mail_Mails WHERE TagNo = Mail_MailTags.TagNo AND IsDelete = FALSE AND ReadDate IS NULL)
		WHERE Mail_MailTags.UserNo = UserNo

		UPDATE Mail_UserSettings SET CurrentMailBoxSize = COALESCE((SELECT SUM(Convert(bigint,Size)) FROM Mail_Mails WHERE UserNo = UserNo AND IsDelete = FALSE),0)
		WHERE UserNo = UserNo

		-----------------------------------------------------------------------------------------

		SET Index = Index + 1

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
