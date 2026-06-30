-- ─── PROCEDURE→FUNCTION: board_getreplyfilebyreplyfileno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getreplyfilebyreplyfileno(bigint);
CREATE OR REPLACE FUNCTION public.board_getreplyfilebyreplyfileno(
    IN replyfileno bigint DEFAULT 7744
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ReplyFileNo,ReplyNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_ReplyFiles
	WHERE ReplyFileNo = board_getreplyfilebyreplyfileno.replyfileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
