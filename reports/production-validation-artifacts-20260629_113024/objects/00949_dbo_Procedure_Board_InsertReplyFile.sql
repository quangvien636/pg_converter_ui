-- ─── PROCEDURE→FUNCTION: board_insertreplyfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertreplyfile(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_insertreplyfile(
    IN replyno bigint,
    IN name character varying,
    IN size integer
) RETURNS SETOF record
AS $function$
DECLARE
    replyfileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Board_ReplyFiles (ReplyNo, Name, Size,Url)
	VALUES (ReplyNo, Name, Size,FilePath)
	

	ReplyFileNo := lastval();
	RETURN QUERY
	SELECT ReplyFileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
