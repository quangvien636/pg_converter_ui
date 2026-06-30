-- ─── PROCEDURE→FUNCTION: board_getfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.board_getfiles(
    IN contentno bigint DEFAULT 5793
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Size,COALESCE(Url,'') AS Url,Sort
	FROM Board_Files
	WHERE ContentNo = board_getfiles.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
