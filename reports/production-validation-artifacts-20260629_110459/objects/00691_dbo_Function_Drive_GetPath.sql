-- ─── FUNCTION: drive_getpath ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getpath();
CREATE OR REPLACE FUNCTION public.drive_getpath(
) RETURNS character varying
AS $function$
BEGIN

	-- Declare the return variable here


	with name_tree as 
	(
	   select FolderNo, ParentNo, Name
	   from Drive_Folders
	   where FolderNo = p_Fno -- this is the starting point you want in your recursion
	   union all
	   select C.FolderNo, C.ParentNo, c.Name
	   from Drive_Folders c
	   join name_tree p on C.FolderNo = P.ParentNo  -- this is the recursion
		AND C.FolderNo<>C.ParentNo AND IsDeleted = FALSE 
	) 

	  SELECT result = STUFF(
				 (SELECT '/' || Name 
				  FROM name_tree order by FolderNo 
				  FOR XML PATH (''))
				 , 1, 1, '')
		-- Return the result of the function
		RETURN result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
