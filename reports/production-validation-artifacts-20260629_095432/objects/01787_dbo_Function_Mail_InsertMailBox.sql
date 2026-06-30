-- ─── FUNCTION: mail_insertmailbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailbox(integer, character varying, bigint);
CREATE OR REPLACE FUNCTION public.mail_insertmailbox(
    userno integer,
    name character varying,
    parentno bigint
) RETURNS TABLE(
    boxno text
)
AS $function$
DECLARE
    boxno bigint;
BEGIN


	INSERT INTO Mail_MailBoxs (UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, UnReadCount, IsShare)
	VALUES(
		UserNo,
		Name,
		ParentNo,
		0,
		NOW(),
		0, 0, 0)
		

	SET BoxNo = lastval()
	
	RETURN QUERY
	SELECT BoxNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
