-- ─── PROCEDURE→FUNCTION: work_getcooperationcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getcooperationcomments(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getcooperationcomments(
    IN groupno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select A.CommentNo,A.CooperationNo,A.GroupNo,A.RegUserNo,B.Name,A.RegDate,A.ModUserNo,
	A.ModDate,A.Content,C.ReadDate from Work_CooperationComments A
	join Organization_Users B
	on A.RegUserNo = B.UserNo
		left join Work_CooperationCommentReference C
	on A.CommentNo = C.CommentNo and C.UserNo = work_getcooperationcomments.userno
	where A.groupno = work_getcooperationcomments.groupno
	order by A.RegDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
