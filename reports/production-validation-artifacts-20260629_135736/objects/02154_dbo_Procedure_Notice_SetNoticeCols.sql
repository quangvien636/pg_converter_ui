-- ─── PROCEDURE→FUNCTION: notice_setnoticecols ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_setnoticecols(boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.notice_setnoticecols(
    IN p_checkbox boolean,
    IN p_important boolean,
    IN p_category boolean,
    IN p_title boolean,
    IN p_writer boolean,
    IN p_writedate boolean,
    IN p_hit boolean,
    IN p_noticedetp boolean,
    IN p_detpshare boolean,
    IN p_noticeperiod boolean
) RETURNS void
AS $function$
BEGIN

	update NoticeCols
	checkbox := notice_setnoticecols.p_checkbox;
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
