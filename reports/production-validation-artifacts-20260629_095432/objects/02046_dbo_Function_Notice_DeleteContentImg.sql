-- ─── FUNCTION: notice_deletecontentimg ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deletecontentimg(integer);
CREATE OR REPLACE FUNCTION public.notice_deletecontentimg(
    noticeno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeContentImgs
	WHERE NoticeNo = notice_deletecontentimg.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
