-- ─── FUNCTION: mail_getdefaultmailboxs ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getdefaultmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getdefaultmailboxs(
    userno integer
) RETURNS TABLE(
    boxno text,
    userno text,
    name text,
    parentno text,
    sortno text,
    moddate text,
    totalcount text,
    unreadcount text,
    isshare text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT BoxNo, UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare
	FROM Mail_MailBoxs
	WHERE UserNo = mail_getdefaultmailboxs.userno AND ParentNo = -1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
