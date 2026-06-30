-- ─── FUNCTION: drive_getlength ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getlength();
CREATE OR REPLACE FUNCTION public.drive_getlength(
) RETURNS bigint
AS $function$
BEGIN


	WITH cte AS 
	 (
		  SELECT FolderNo, ParentNo
		  FROM Drive_Folders a
		  WHERE FolderNo = p_no
		  UNION ALL
		  SELECT a.FolderNo, a.ParentNo
		  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo -- AND IsDeleted = FALSE
	  ) 
	select result= COALESCE((select SUM(Length) from Drive_Files
						where IsDeleted = FALSE and FolderNo in ( select FolderNo from cte)),0)
    RETURN result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
