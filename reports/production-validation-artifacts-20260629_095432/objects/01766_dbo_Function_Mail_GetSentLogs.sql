-- ─── FUNCTION: mail_getsentlogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsentlogs(bigint);
CREATE OR REPLACE FUNCTION public.mail_getsentlogs(
    mailno bigint
) RETURNS TABLE(
    logno text,
    cmsendnum text,
    name text,
    address text,
    senttype text,
    iscomplete text,
    iscancel text,
    readdate text,
    recipientuserno text,
    receivedmailno text,
    receivedmailreaddate text,
    delivereddate text,
    maildomain text,
    mailaccount text,
    emlfilename text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT S.LogNo, S.CMSendNum, S.Name, S.Address, S.SentType, S.IsComplete, S.IsCancel, S.ReadDate,
		COALESCE(P.UserNo, 0) AS RecipientUserNo,
		COALESCE(M.MailNo, 0) AS ReceivedMailNo, M.ReadDate AS ReceivedMailReadDate, S.DeliveredDate,
		COALESCE(M.ToDomain, '') AS MailDomain, COALESCE(P2.PopUser, '') AS MailAccount,
		COALESCE(M.EmlFileName, '') AS EmlFileName
	FROM Mail_SentLogs S
	LEFT JOIN Mail_Accounts P ON P.MailAddress = LTRIM(RTRIM(S.Address))
	LEFT JOIN Mail_Mails M ON M.UserNo = P.UserNo AND IsSent = FALSE AND M.CMSendNum = S.CMSendNum and 
	(STRPOS(M.To, P.MailAddress) > 0 or STRPOS(M.Cc, P.MailAddress) > 0 or STRPOS(M.Bcc, P.MailAddress) > 0)
	LEFT JOIN Mail_Accounts P2 ON P2.AccountNo = M.AccNo
	WHERE S.MailNo = mail_getsentlogs.mailno 
	ORDER BY LogNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
