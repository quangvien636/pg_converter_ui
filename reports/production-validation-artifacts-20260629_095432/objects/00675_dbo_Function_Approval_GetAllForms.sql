-- ─── FUNCTION: approval_getallforms ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getallforms();
CREATE OR REPLACE FUNCTION public.approval_getallforms(
) RETURNS TABLE(
    categoryno text,
    formno text,
    name text,
    filetype text,
    fileno text,
    depth text
)
AS $function$
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
