-- ─── FUNCTION: mail_getmailboxs ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailboxs(
    userno integer
) RETURNS TABLE(
    boxno text,
    userno text,
    name text,
    parentno text,
    sortno text,
    moddate text,
    totalcount text,
    col8 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BoxNo, UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, 
	CASE SortNo  
	WHEN 7 THEN (SELECT /* TOP 1 */ UnReadCount FROM Mail_MailBoxs B where B.UserNo = mail_getmailboxs.userno and SortNo = 1) 
	ELSE UnReadCount 
	END UnReadCount,
	IsShare
	FROM Mail_MailBoxs
	WHERE UserNo = mail_getmailboxs.userno
	ORDER BY SortNo DESC, Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
