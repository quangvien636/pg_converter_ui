-- ─── PROCEDURE→FUNCTION: notice_addorg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_addorg(integer);
CREATE OR REPLACE FUNCTION public.notice_addorg(
    IN p_no integer
) RETURNS void
AS $function$
BEGIN


    IF( dno = 0)
	BEGIN;
		INSERT INTO NoticePermissions (DeparNo) VALUES(p_no)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
