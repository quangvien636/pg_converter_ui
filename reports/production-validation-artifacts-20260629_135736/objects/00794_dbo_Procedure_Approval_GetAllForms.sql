-- ─── PROCEDURE→FUNCTION: approval_getallforms ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_getallforms();
CREATE OR REPLACE FUNCTION public.approval_getallforms(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		ROW_NUMBER() OVER(ORDER BY CategoryNo, FormNo) AS RowNum, 
		CategoryNo,
		FormNo,
		Name,
		FileType,
		FileNo,
		Depth
	FROM
	(	
		SELECT CategoryNo, -1 AS FormNo, Name, -1 As FileType, -1 As FileNo, 1 AS Depth 
		FROM Approval_FormCategories
		UNION ALL
		SELECT CategoryNo, FormNo, Name, FileType, FileNo, 2 As Depth
		FROM ApprovalForms
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
