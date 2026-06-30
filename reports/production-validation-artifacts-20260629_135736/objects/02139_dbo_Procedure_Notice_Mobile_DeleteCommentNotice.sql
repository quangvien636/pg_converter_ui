-- ─── PROCEDURE→FUNCTION: notice_mobile_deletecommentnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_mobile_deletecommentnotice(integer);
CREATE OR REPLACE FUNCTION public.notice_mobile_deletecommentnotice(
    IN commentno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM NoticeComments WHERE CommentNo = notice_mobile_deletecommentnotice.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
