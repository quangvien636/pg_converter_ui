-- ─── PROCEDURE→FUNCTION: drive_movedown ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_movedown();
CREATE OR REPLACE FUNCTION public.drive_movedown(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	With cte As
	(
		SELECT FolderNo,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, DateModified ASC) AS RN
		FROM Drive_Folders where ParentNo = parentid AND IsDeleted = FALSE
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE Drive_Folders set Sort = Sort + 1.01 Where FolderNo =  p_Fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
