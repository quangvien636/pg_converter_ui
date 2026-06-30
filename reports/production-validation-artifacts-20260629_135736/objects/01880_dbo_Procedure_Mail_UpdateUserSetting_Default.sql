-- ─── PROCEDURE→FUNCTION: mail_updateusersetting_default ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updateusersetting_default(integer, bigint, boolean, integer, boolean, boolean, boolean, boolean, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_updateusersetting_default(
    IN userno integer,
    IN startmailboxno bigint,
    IN isfolderexpanded boolean,
    IN pagepercount integer,
    IN istitleoneline boolean,
    IN isasnameaddress boolean,
    IN isconversationlist boolean,
    IN isaddressareaexpanded boolean,
    IN isnotsavingsentmail boolean,
    IN autosavingtime integer,
    IN isincludedreference integer
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_UserSettings SET
		StartMailBoxNo = mail_updateusersetting_default.startmailboxno,
		IsFolderExpanded = mail_updateusersetting_default.isfolderexpanded,
		PagePerCount = mail_updateusersetting_default.pagepercount,
		IsTitleOneLine = mail_updateusersetting_default.istitleoneline,
		IsAsNameAddress = mail_updateusersetting_default.isasnameaddress,
		IsConversationList = mail_updateusersetting_default.isconversationlist,
		IsAddressAreaExpanded = mail_updateusersetting_default.isaddressareaexpanded,
		IsNotSavingSentMail = mail_updateusersetting_default.isnotsavingsentmail,
		AutoSavingTime = mail_updateusersetting_default.autosavingtime,
		IsIncludedReference = mail_updateusersetting_default.isincludedreference
    WHERE UserNo = mail_updateusersetting_default.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
