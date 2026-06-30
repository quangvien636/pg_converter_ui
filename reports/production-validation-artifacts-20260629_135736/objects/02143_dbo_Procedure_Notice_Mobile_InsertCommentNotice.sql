-- ─── PROCEDURE→FUNCTION: notice_mobile_insertcommentnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_mobile_insertcommentnotice(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.notice_mobile_insertcommentnotice(
    IN noticeno integer,
    IN reguserno integer,
    IN regdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    commentno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO NoticeComments (NoticeNo, RegUserNo, RegDate, ModUserNo, ModDate, Content)
	VALUES (NoticeNo, RegUserNo, RegDate, RegUserNo, RegDate, Content)


	CommentNo := lastval();
	RETURN QUERY
	SELECT CommentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
