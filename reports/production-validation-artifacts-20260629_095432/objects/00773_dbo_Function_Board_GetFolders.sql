-- ─── FUNCTION: board_getfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getfolders(boolean, integer);
CREATE OR REPLACE FUNCTION public.board_getfolders(
    isdisabled boolean DEFAULT FALSE,
    userno integer DEFAULT 74
) RETURNS TABLE(
    folderno text,
    moduserno text,
    moddate text,
    name text,
    parentno text,
    sortno text,
    enabled text,
    levelrand text,
    spectype text,
    col10 text
)
AS $function$
BEGIN


	--IF (IsDisabled = TRUE) BEGIN

		WITH  History AS (
				SELECT *, ROW_NUMBER() OVER (PARTITION BY  UserNo,FolderNo ORDER BY HistoryFolderNo) AS RowNum FROM Board_HistoryFolder WHERE UserNo=board_getfolders.userno
			)
		RETURN QUERY
		SELECT BF.FolderNo, BF.ModUserNo, BF.ModDate, BF.Name, BF.ParentNo, BF.SortNo, BF.Enabled, COALESCE(BF.LevelRand,',') AS LevelRand,BF.SpecType,COALESCE(BH.IsOpen,1) AS IsOpen
		FROM Board_Folders BF
		LEFT JOIN History BH ON BH.UserNo=board_getfolders.userno AND BF.FolderNo=BH.FolderNo AND BH.RowNum=1
		WHERE Enabled = ~IsDisabled 
		ORDER BY BF.SortNo ASC,BF.FolderNo ASC;

	--END
	
	--ELSE BEGIN
	
	--	SELECT BF.FolderNo, BF.ModUserNo, BF.ModDate, BF.Name, BF.ParentNo, BF.SortNo, BF.Enabled, COALESCE(BF.LevelRand,',') AS LevelRand,BF.SpecType,COALESCE(BH.IsOpen,1) AS IsOpen
	--	FROM Board_Folders BF
	--    LEFT JOIN Board_HistoryFolder BH ON BH.UserNo=UserNo AND BF.FolderNo=BH.FolderNo
	--	WHERE Enabled = TRUE
	--	ORDER BY BF.SortNo ASC,BF.FolderNo ASC
	
	--END
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
