-- ─── FUNCTION: mail_getusersetting_default ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getusersetting_default(integer);
CREATE OR REPLACE FUNCTION public.mail_getusersetting_default(
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
    isnotsavingsentmail text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT StartMailBoxNo, IsFolderExpanded, PagePerCount, IsTitleOneLine,
		IsAsNameAddress, IsConversationList, IsAddressAreaExpanded, AutoSavingTime, IsIncludedReference, IsNotSavingSentMail
	FROM Mail_UserSettings WHERE UserNo = mail_getusersetting_default.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
