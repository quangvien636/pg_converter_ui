-- ─── PROCEDURE→FUNCTION: notice_restorenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_restorenotice();
CREATE OR REPLACE FUNCTION public.notice_restorenotice(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


CREATE TEMP TABLE tam AS SELECT VALUE FROM public."UF_TEXT_SPLIT"(p_nos,';');

	insert into Notices(NoticeNo,RegUserNo,RegDate,ModUserNo,ModDate,Title
						,DivisionNo,Content,StartDate,EndDate,Important,IsShare,IsAttach,TotalViews
						,CurrentViews,IsContentImg,IsPopup,DepartNo,PPStartDate,PPEndDate)
	RETURN QUERY
	select 
		d.NoticeNo
		,d.RegUserNo
		,d.RegDate
		,d.ModUserNo
		,d.ModDate
		,d.Title
		,d.DivisionNo
		,d.Content
		,d.StartDate
		,d.EndDate
		,d.Important
		,d.IsShare
		,d.IsAttach
		,d.TotalViews
		,d.CurrentViews
		,d.IsContentImg
		,d.IsPopup
		,d.DepartNo
		,d.PPStartDate
		,d.PPEndDate
	from NoticesDelete d where d.NoticeNo in( select * from tam);;
	DELETE FROM NoticesDelete  where NoticeNo in( select * from tam);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
