-- ─── FUNCTION: notice_updateimportant ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updateimportant(integer, boolean);
CREATE OR REPLACE FUNCTION public.notice_updateimportant(
    noticeno integer,
    important boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Notices
	SET Important = notice_updateimportant.important
	WHERE  NoticeNo = notice_updateimportant.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
