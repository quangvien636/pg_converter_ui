-- ─── PROCEDURE→FUNCTION: notice_mobile_getcontentnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_mobile_getcontentnotice(integer);
CREATE OR REPLACE FUNCTION public.notice_mobile_getcontentnotice(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT NoticeNo, RegUserNo, RegDate, ModUserNo, ModDate, Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg
	FROM Notices
	WHERE NoticeNo = notice_mobile_getcontentnotice.noticeno

	RETURN QUERY
	SELECT AttachNo, FileName, FileLength, FilePath
	FROM NoticeAttachments
	WHERE NoticeNo = notice_mobile_getcontentnotice.noticeno
	ORDER BY AttachNo ASC

	RETURN QUERY
	SELECT CommentNo, RegUserNo, RegDate, ModUserNo, ModDate, Content
	FROM NoticeComments
	WHERE NoticeNo = notice_mobile_getcontentnotice.noticeno
	ORDER BY CommentNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
