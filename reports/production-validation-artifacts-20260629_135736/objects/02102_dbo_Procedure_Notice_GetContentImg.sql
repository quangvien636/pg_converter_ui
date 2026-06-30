-- ─── PROCEDURE→FUNCTION: notice_getcontentimg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getcontentimg(integer);
CREATE OR REPLACE FUNCTION public.notice_getcontentimg(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT ContentImgNo,NoticeNo,FileName,FileSize,Path FROM NoticeContentImgs
	WHERE NoticeNo=notice_getcontentimg.noticeno
	ORDER BY ContentImgNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
