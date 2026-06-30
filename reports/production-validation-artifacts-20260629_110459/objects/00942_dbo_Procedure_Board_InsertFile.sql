-- ─── PROCEDURE→FUNCTION: board_insertfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertfile(bigint, character varying, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_insertfile(
    IN contentno bigint DEFAULT 5785,
    IN name character varying DEFAULT '2023-T5-2X(VN-SB)(9).pdf',
    IN size integer DEFAULT 107432,
    IN filepath character varying DEFAULT '/_Repository/_Board/Attach/5785/2023-T5-2X(VN-SB)(9).pdf',
    IN sort integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Board_Files (ContentNo, Name, Size,Url,Sort)
	VALUES (ContentNo, Name, Size,FilePath,Sort)
	

	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
