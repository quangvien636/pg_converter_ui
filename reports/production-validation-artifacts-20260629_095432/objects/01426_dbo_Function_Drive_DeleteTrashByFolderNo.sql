-- ─── FUNCTION: drive_deletetrashbyfolderno ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletetrashbyfolderno(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletetrashbyfolderno(
    p_no bigint
) RETURNS void
AS $function$
BEGIN

	WITH cte AS 
	 (
		  SELECT FolderNo, ParentNo
		  FROM Drive_Folders a
		  WHERE FolderNo = drive_deletetrashbyfolderno.p_no
		  UNION ALL
		  SELECT a.FolderNo, a.ParentNo
		  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo  AND IsDeleted = TRUE
	  )
	select FolderNo into #tam from cte;;
	DELETE FROM Drive_Trash   
	WHERE FolderNo IN(SELECT FolderNo FROM #tam);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
