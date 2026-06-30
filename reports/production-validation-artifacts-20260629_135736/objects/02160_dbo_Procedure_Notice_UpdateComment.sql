-- ─── PROCEDURE→FUNCTION: notice_updatecomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updatecomment(integer);
CREATE OR REPLACE FUNCTION public.notice_updatecomment(
    IN commentno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeComments 
	Content := Content, ModDate = NOW();
	WHERE CommentNo = notice_updatecomment.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
