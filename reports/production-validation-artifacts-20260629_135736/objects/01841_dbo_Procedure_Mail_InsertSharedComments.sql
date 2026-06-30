-- ─── PROCEDURE→FUNCTION: mail_insertsharedcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_insertsharedcomments(bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertsharedcomments(
    IN mailno bigint,
    IN reguserno integer,
    IN commentstype integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_SharedComments(MailNo,RegUserNo,RegDate,ModDate,CommentsType,Content) 
	VALUES (MailNo,RegUserNo, NOW(), NOW(),CommentsType,Content);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
