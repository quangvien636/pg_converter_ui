-- ─── PROCEDURE→FUNCTION: mail_deletesharedcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletesharedcomments(integer);
CREATE OR REPLACE FUNCTION public.mail_deletesharedcomments(
    IN commentno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_SharedComments WHERE CommentNo = mail_deletesharedcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
