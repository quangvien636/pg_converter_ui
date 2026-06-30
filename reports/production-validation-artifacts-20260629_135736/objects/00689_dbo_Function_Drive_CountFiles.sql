-- ─── FUNCTION: drive_countfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_countfiles();
CREATE OR REPLACE FUNCTION public.drive_countfiles(
) RETURNS integer
AS $function$
BEGIN

	-- Declare the return variable here


	WITH cte AS 
	 (
		  SELECT FolderNo, ParentNo, Name
		  FROM Drive_Folders a
		  WHERE FolderNo = p_Fno
		  UNION ALL
		  SELECT a.FolderNo, a.ParentNo, a.Name
		  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo  AND IsDeleted = FALSE
	  )

	  SELECT result = (select count(1) as CountFile from Drive_Files where IsDeleted = FALSE and FolderNo in (select FolderNo from  cte t))
	  RETURN result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
