-- ─── PROCEDURE→FUNCTION: board_getreplyfilebycontentno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getreplyfilebycontentno(bigint);
CREATE OR REPLACE FUNCTION public.board_getreplyfilebycontentno(
    IN contentno bigint DEFAULT 5158
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BR.ReplyNo, RF.ReplyFileNo, RF.Name, RF.Size,COALESCE(RF.Url,'') AS Url
	FROM Board_ReplyFiles RF
	INNER JOIN Board_Replies BR ON BR.ReplyNo=RF.ReplyNo 
	WHERE BR.ContentNo = board_getreplyfilebycontentno.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
