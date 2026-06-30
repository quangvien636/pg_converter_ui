-- ─── PROCEDURE→FUNCTION: mail_updatesharedcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatesharedcomments(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_updatesharedcomments(
    IN commentno integer,
    IN commentstype integer
) RETURNS void
AS $function$
BEGIN


	update Mail_SharedComments
	ModDate := NOW();
	,CommentsType = mail_updatesharedcomments.commentstype
	,Content =Content
	WHERE CommentNo = mail_updatesharedcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
