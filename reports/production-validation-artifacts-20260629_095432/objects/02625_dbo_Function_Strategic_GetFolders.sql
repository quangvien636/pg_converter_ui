-- ─── FUNCTION: strategic_getfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.strategic_getfolders(boolean);
CREATE OR REPLACE FUNCTION public.strategic_getfolders(
    isdisabled boolean
) RETURNS TABLE(
    folderno text,
    moduserno text,
    moddate text,
    name text,
    parentno text,
    sortno text,
    enabled text,
    levelrand text,
    spectype text
)
AS $function$
BEGIN


	IF (IsDisabled = TRUE) BEGIN

		RETURN QUERY
		SELECT FolderNo, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled, LevelRand,SpecType
		FROM Strategic_Folders
		ORDER BY SortNo ASC,FolderNo ASC

	END
	
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
