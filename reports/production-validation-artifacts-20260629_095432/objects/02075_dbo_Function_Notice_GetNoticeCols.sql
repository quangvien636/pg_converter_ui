-- ─── FUNCTION: notice_getnoticecols ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getnoticecols();
CREATE OR REPLACE FUNCTION public.notice_getnoticecols(
) RETURNS TABLE(
    id text,
    checkbox text,
    important text,
    category text,
    title text,
    writer text,
    writedate text,
    hit text,
    noticedetp text,
    noticedetpshare text,
    noticeperiod text
)
AS $function$
BEGIN

	if((select count(*) from NoticeCols)>0) begin 
		RETURN QUERY
		SELECT Id,	checkbox,	important,	category,	title,	writer,	WriteDate,	Hit,	NoticeDetp,NoticeDetpShare,	NoticePeriod FROM NoticeCols
	end
	else begin;
		insert into NoticeCols(checkbox,	important,	category,	title,	writer,	WriteDate,	Hit,	NoticeDetp,NoticeDetpShare,	NoticePeriod) 
		values(1,	1,	1,	1,	1,	1,	1,	1,	1, 1)
		RETURN QUERY
		SELECT Id,	checkbox,	important,	category,	title,	writer,	WriteDate,	Hit,	NoticeDetp,NoticeDetpShare,	NoticePeriod FROM NoticeCols
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
