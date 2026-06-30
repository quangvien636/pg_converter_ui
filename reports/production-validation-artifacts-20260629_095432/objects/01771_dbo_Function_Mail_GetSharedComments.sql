-- ─── FUNCTION: mail_getsharedcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsharedcomments(bigint);
CREATE OR REPLACE FUNCTION public.mail_getsharedcomments(
    mailno bigint
) RETURNS TABLE(
    commentno text,
    mailno text,
    reguserno text,
    regdate text,
    moddate text,
    content text,
    commentstype text,
    username text
)
AS $function$
BEGIN


	RETURN QUERY
	select A.CommentNo, A.MailNo, A.RegUserNo, A.RegDate, A.ModDate, A.Content ,A.CommentsType ,B.Name as UserName
	from Mail_SharedComments A
	join Organization_Users B
	on A.RegUserNo = B.UserNo
	where A.MailNo = mail_getsharedcomments.mailno
	order by A.ModDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
