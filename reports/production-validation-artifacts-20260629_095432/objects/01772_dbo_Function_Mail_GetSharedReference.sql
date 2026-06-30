-- ─── FUNCTION: mail_getsharedreference ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsharedreference(bigint);
CREATE OR REPLACE FUNCTION public.mail_getsharedreference(
    mailno bigint
) RETURNS TABLE(
    referenceno text,
    mailno text,
    userno text,
    readdate text,
    moddate text,
    username text
)
AS $function$
BEGIN


	RETURN QUERY
	select A.ReferenceNo,A.MailNo,A.UserNo,A.ReadDate,A.ModDate ,B.Name as UserName
	from Mail_SharedReference A
	join Organization_Users B
	on A.UserNo = B.UserNo
	where A.MailNo = mail_getsharedreference.mailno
	order by A.ReadDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
