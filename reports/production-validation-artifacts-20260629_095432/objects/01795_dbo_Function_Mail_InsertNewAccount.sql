-- ─── FUNCTION: mail_insertnewaccount ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertnewaccount(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertnewaccount(
    userno integer,
    reguserno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    mailsize integer;
    allmailbox bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	



	SELECT MailSize = Value from Center_Configuration WHERE key = 'KEY_USE_USER_MAILSIZE'
	IF(MailSize is null)
	BEGIN
	 SET MailSize = 20480
	END


	SELECT Password = Password, Name = Name, MailAddress = MailAddress
	FROM Organization_Users
	WHERE UserNo = mail_insertnewaccount.userno

	SELECT Server = ServerHost
	FROM Mail_Servers
	WHERE STRPOS(MailAddress, MailDomain) > 1

	IF(Server != '')
	BEGIN

		INSERT INTO Mail_Accounts
		VALUES (UserNo, RegUserNo, NOW(), Server, 110, MailAddress, Password, 1, 0, 0, 1, Name, MailAddress, 1)


		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 1, NOW(), 0, 0, 0)

		SET AllMailBox = lastval()

		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 2, NOW(), 0, 0, 0);
		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 3, NOW(), 0, 0, 0);
		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 4, NOW(), 0, 0, 0);
		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 5, NOW(), 0, 0, 0);
		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 6, NOW(), 0, 0, 0);
		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 7, NOW(), 0, 0, 0);
		INSERT INTO Mail_MailBoxs VALUES (UserNo, '', -1, 8, NOW(), 0, 0, 0)

		INSERT INTO Mail_UserSettings (UserNo, StartMailBoxNo, IsFolderExpanded, PagePerCount, IsTitleOneLine, IsAsNameAddress,
			IsConversationList, IsAddressAreaExpanded, IsIncludedReference, UseSign, MailBoxSize, CurrentMailBoxSize,
			IsNotSavingSentMail, AutoSavingTime, MailBoxLimit, OpenMailBoxs)
		VALUES (UserNo, AllMailBox, 0, 20, 0, 0,
			0, 0, 0, 0, MailSize, 0,
			0, -1, 0, '[]')

		INSERT INTO Mail_CMSettings values(UserNo,SUBSTRING(MailAddress, 0, STRPOS(MailAddress, '@')),
		SUBSTRING(MailAddress, STRPOS(MailAddress, '@') +  1 ,len(MailAddress)),'',''
		,'1900-01-01 00:00:00.000','1900-01-01 00:00:00.000',0,'','')

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
