-- ─── PROCEDURE→FUNCTION: notice_getcomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getcomment(integer);
CREATE OR REPLACE FUNCTION public.notice_getcomment(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT CommentNo,C.RegUserNo,Name,C.RegDate,C.ModUserNo,
	C.ModDate,C.Content,U.Photo,COALESCE(C.ModUserName,'') as UserName, COALESCE(C.ModPositionNo,0) as PositionNo,
	COALESCE(C.ModPositionName,'') as PositionName,COALESCE(C.ModDepartNo,0) as DepartNo,COALESCE(C.ModDepartName,'') as DepartName,COALESCE(C.GroupNo,0) as GroupNo,
	COALESCE(C.Depth,0) as Depth,COALESCE(C.OrderNo,0) as OrderNo
	FROM NoticeComments C
	INNER JOIN Organization_Users U ON C.RegUserNo = U.UserNo
	WHERE NoticeNo = notice_getcomment.noticeno
	ORDER BY C.GroupNo DESC, C.OrderNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
