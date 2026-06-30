-- ─── PROCEDURE→FUNCTION: notice_getnoticecols ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getnoticecols();
CREATE OR REPLACE FUNCTION public.notice_getnoticecols(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	if((select count(*) from NoticeCols)>0) begin 
		RETURN QUERY
		SELECT Id,	checkbox,	important,	category,	title,	writer,	WriteDate,	Hit,	NoticeDetp,NoticeDetpShare,	NoticePeriod FROM NoticeCols
	END;
	else begin;
		insert into NoticeCols(checkbox,	important,	category,	title,	writer,	WriteDate,	Hit,	NoticeDetp,NoticeDetpShare,	NoticePeriod) 
		values(1,	1,	1,	1,	1,	1,	1,	1,	1, 1)
		RETURN QUERY
		SELECT Id,	checkbox,	important,	category,	title,	writer,	WriteDate,	Hit,	NoticeDetp,NoticeDetpShare,	NoticePeriod FROM NoticeCols
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
