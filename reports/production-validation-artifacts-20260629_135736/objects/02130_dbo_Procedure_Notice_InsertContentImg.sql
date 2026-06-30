-- ─── PROCEDURE→FUNCTION: notice_insertcontentimg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_insertcontentimg(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertcontentimg(
    IN noticeno integer,
    IN filename character varying,
    IN filesize integer
) RETURNS SETOF record
AS $function$
DECLARE
    contentimgno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	INSERT INTO NoticeContentImgs
	(NoticeNo,FileName,FileSize,Path)
	VALUES
	(NoticeNo, FileName, FileSize, Path)
	

	ContentImgNo := lastval();
	RETURN QUERY
	SELECT ContentImgNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
