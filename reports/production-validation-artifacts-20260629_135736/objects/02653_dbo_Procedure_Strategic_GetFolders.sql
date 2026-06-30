-- ─── PROCEDURE→FUNCTION: strategic_getfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.strategic_getfolders(boolean);
CREATE OR REPLACE FUNCTION public.strategic_getfolders(
    IN isdisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDisabled = TRUE THEN

		RETURN QUERY
		SELECT FolderNo, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled, LevelRand,SpecType
		FROM Strategic_Folders
		ORDER BY SortNo ASC,FolderNo ASC

	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT FolderNo, ModUserNo, ModDate, Name, ParentNo,SortNo, Enabled, LevelRand,SpecType
		FROM Strategic_Folders
		WHERE Enabled = TRUE
		ORDER BY SortNo ASC,FolderNo ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
