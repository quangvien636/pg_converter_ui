-- ─── PROCEDURE→FUNCTION: mail_cleanupcountofmailboxs_userno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_cleanupcountofmailboxs_userno(integer);
CREATE OR REPLACE FUNCTION public.mail_cleanupcountofmailboxs_userno(
    IN userno integer
) RETURNS void
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
BEGIN

	
	,
		UserNo		INT
	)

	INSERT INTO ListOfUsers
	SELECT UserNo FROM Organization_Users WHERE Enabled = TRUE and UserNo = mail_cleanupcountofmailboxs_userno.userno

	-------------------------------------------------------------------------------------------




	Index := 1;
	TotalCount := (SELECT COUNT(*) FROM ListOfUsers);
	WHILE Index <= TotalCount LOOP

		DELETE FROM AllBoxs
		_UserNo := (SELECT UserNo FROM ListOfUsers WHERE Index = Index);
		-----------------------------------------------------------------------------------------

		INSERT INTO AllBoxs
		SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(_UserNo)

		UPDATE Mail_MailBoxs SET
			TotalCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo = Mail_MailBoxs.BoxNo AND IsDelete = FALSE),
			UnReadCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo = Mail_MailBoxs.BoxNo AND IsDelete = FALSE AND ReadDate IS NULL)
		WHERE Mail_MailBoxs.UserNo = _UserNo

		UPDATE Mail_MailBoxs SET 
			TotalCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo IN (SELECT BoxNo FROM AllBoxs) AND IsDelete = FALSE),
			UnReadCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo IN (SELECT BoxNo FROM AllBoxs) AND IsDelete = FALSE AND ReadDate IS NULL)
		WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = _UserNo AND ParentNo = -1 AND SortNo = 1)

		UPDATE Mail_MailTags SET
			TotalCount = (SELECT COUNT(*) FROM Mail_Mails WHERE TagNo = Mail_MailTags.TagNo AND IsDelete = FALSE),
			UnReadCount = (SELECT COUNT(*) FROM Mail_Mails WHERE TagNo = Mail_MailTags.TagNo AND IsDelete = FALSE AND ReadDate IS NULL)
		WHERE Mail_MailTags.UserNo = _UserNo

		UPDATE Mail_UserSettings SET CurrentMailBoxSize = COALESCE((SELECT SUM(Convert(bigint,Size)) FROM Mail_Mails WHERE UserNo = _UserNo AND IsDelete = FALSE),0)
		WHERE UserNo = _UserNo

		-----------------------------------------------------------------------------------------

		Index := Index + 1;
	END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
