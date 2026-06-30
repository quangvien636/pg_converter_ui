-- ─── PROCEDURE→FUNCTION: work_updatecooperationcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updatecooperationcomments(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updatecooperationcomments(
    IN commentno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	update Work_CooperationComments
	ModUserNo := work_updatecooperationcomments.moduserno;
	,ModDate = work_updatecooperationcomments.moddate
	,Content =Content
	WHERE CommentNo = work_updatecooperationcomments.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
