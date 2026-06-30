-- ─── PROCEDURE→FUNCTION: board_getfolderbyfolderno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getfolderbyfolderno(integer);
CREATE OR REPLACE FUNCTION public.board_getfolderbyfolderno(
    IN folderno integer DEFAULT 49
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
		RETURN QUERY
		SELECT FolderNo, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled, LevelRand,SpecType
		FROM Board_Folders where FolderNo=board_getfolderbyfolderno.folderno
		ORDER BY SortNo ASC,FolderNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
