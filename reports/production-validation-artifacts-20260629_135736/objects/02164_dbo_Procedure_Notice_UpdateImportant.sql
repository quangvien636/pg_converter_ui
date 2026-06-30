-- ─── PROCEDURE→FUNCTION: notice_updateimportant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updateimportant(integer, boolean);
CREATE OR REPLACE FUNCTION public.notice_updateimportant(
    IN noticeno integer,
    IN important boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Notices
	Important := notice_updateimportant.important;
	WHERE  NoticeNo = notice_updateimportant.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
