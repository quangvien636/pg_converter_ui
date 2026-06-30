-- ─── PROCEDURE→FUNCTION: notice_deletecontentimg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_deletecontentimg(integer);
CREATE OR REPLACE FUNCTION public.notice_deletecontentimg(
    IN noticeno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeContentImgs
	WHERE NoticeNo = notice_deletecontentimg.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
