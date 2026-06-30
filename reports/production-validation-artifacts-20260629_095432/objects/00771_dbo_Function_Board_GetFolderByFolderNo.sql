-- ─── FUNCTION: board_getfolderbyfolderno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getfolderbyfolderno(integer);
CREATE OR REPLACE FUNCTION public.board_getfolderbyfolderno(
    folderno integer DEFAULT 49
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


	
		RETURN QUERY
		SELECT FolderNo, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled, LevelRand,SpecType
		FROM Board_Folders where FolderNo=board_getfolderbyfolderno.folderno
		ORDER BY SortNo ASC,FolderNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
