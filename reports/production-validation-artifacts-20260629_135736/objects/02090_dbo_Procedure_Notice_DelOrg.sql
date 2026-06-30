-- ─── PROCEDURE→FUNCTION: notice_delorg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_delorg(integer);
CREATE OR REPLACE FUNCTION public.notice_delorg(
    IN p_no integer
) RETURNS void
AS $function$
BEGIN


		DELETE FROM NoticePermissions  WHERE DeparNo = notice_delorg.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
