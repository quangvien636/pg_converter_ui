-- ─── FUNCTION: mail_insertdefaultsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertdefaultsetting(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_insertdefaultsetting(
    userno integer,
    mailboxsize bigint
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    mailaddress character varying;
    startmailboxno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT MailAddress = MailAddress
	FROM Organization_Users
	WHERE UserNo = mail_insertdefaultsetting.userno
	

	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 1, NOW(), 0, 0, 0)
	
	SET StartMailBoxNo = lastval()
	
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 2, NOW(), 0, 0, 0);
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 3, NOW(), 0, 0, 0);
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 4, NOW(), 0, 0, 0);
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 5, NOW(), 0, 0, 0);
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 6, NOW(), 0, 0, 0);
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 7, NOW(), 0, 0, 0);
	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES (UserNo, '', -1, 8, NOW(), 0, 0, 0)

	INSERT INTO Mail_UserSettings (UserNo, StartMailBoxNo ,IsFolderExpanded, PagePerCount, IsTitleOneLine, IsAsNameAddress,
		IsConversationList, IsAddressAreaExpanded, AutoSavingTime, IsIncludedReference, UseSign, MailBoxSize,
		CurrentMailBoxSize, MailBoxLimit, OpenMailBoxs,IsNotSavingSentMail)
	VALUES (UserNo, StartMailBoxNo ,0, 20, 0, 0,
		0, 0, -1, 0, 0, MailBoxSize,
		0, 0, '[]',0)

	INSERT INTO Mail_CMSettings values(UserNo,SUBSTRING(MailAddress, 0, STRPOS(MailAddress, '@')),
	SUBSTRING(MailAddress, STRPOS(MailAddress, '@') +  1 ,len(MailAddress)),'',''
	,'1900-01-01 00:00:00.000','1900-01-01 00:00:00.000',0,'','');
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
