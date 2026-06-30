-- ─── FUNCTION: notice_isview ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_isview(integer);
CREATE OR REPLACE FUNCTION public.notice_isview(
    p_noticeno integer
) RETURNS integer
AS $function$
BEGIN

	
	return (select  COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_isview.p_noticeno AND Userid = p_id);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
