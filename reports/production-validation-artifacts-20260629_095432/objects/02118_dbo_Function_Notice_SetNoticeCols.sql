-- ─── FUNCTION: notice_setnoticecols ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setnoticecols(boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.notice_setnoticecols(
    p_checkbox boolean,
    p_important boolean,
    p_category boolean,
    p_title boolean,
    p_writer boolean,
    p_writedate boolean,
    p_hit boolean,
    p_noticedetp boolean,
    p_detpshare boolean,
    p_noticeperiod boolean
) RETURNS void
AS $function$
BEGIN

	update NoticeCols
	set checkbox = notice_setnoticecols.p_checkbox
	,	important = notice_setnoticecols.p_important
	,	category = notice_setnoticecols.p_category
	,	title = notice_setnoticecols.p_title
	,	writer = notice_setnoticecols.p_writer
	,	WriteDate = notice_setnoticecols.p_writedate
	,	Hit = notice_setnoticecols.p_hit
	,	NoticeDetp = notice_setnoticecols.p_noticedetp
	,	NoticeDetpShare  = notice_setnoticecols.p_detpshare 
	,	NoticePeriod = notice_setnoticecols.p_noticeperiod;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
