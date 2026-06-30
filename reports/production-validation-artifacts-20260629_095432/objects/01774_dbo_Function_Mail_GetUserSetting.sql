-- ─── FUNCTION: mail_getusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.mail_getusersetting(
    userno integer
) RETURNS TABLE(
    startmailboxno text,
    isfolderexpanded text,
    pagepercount text,
    istitleoneline text,
    isasnameaddress text,
    isconversationlist text,
    isaddressareaexpanded text,
    autosavingtime text,
    isincludedreference text,
    isnotsavingsentmail text,
    usesign text,
    mailboxsize text,
    currentmailboxsize text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT StartMailBoxNo, IsFolderExpanded, PagePerCount, IsTitleOneLine, IsAsNameAddress, IsConversationList, IsAddressAreaExpanded, AutoSavingTime, IsIncludedReference, IsNotSavingSentMail,
		UseSign,
		MailBoxSize, CurrentMailBoxSize
	FROM Mail_UserSettings WHERE UserNo = mail_getusersetting.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
