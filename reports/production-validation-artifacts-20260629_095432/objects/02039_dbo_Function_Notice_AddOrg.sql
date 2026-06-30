-- ─── FUNCTION: notice_addorg ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_addorg(integer);
CREATE OR REPLACE FUNCTION public.notice_addorg(
    p_no integer
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
