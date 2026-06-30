-- ─── PROCEDURE→FUNCTION: work_readcooperationcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_readcooperationcomments(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_readcooperationcomments(
    IN commentno integer,
    IN userno integer,
    IN readdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Work_CooperationCommentReference VALUES (CommentNo, UserNo,ReadDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
