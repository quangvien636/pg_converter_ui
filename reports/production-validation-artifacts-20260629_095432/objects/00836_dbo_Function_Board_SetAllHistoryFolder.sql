-- ─── FUNCTION: board_setallhistoryfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_setallhistoryfolder(integer, boolean);
CREATE OR REPLACE FUNCTION public.board_setallhistoryfolder(
    userno integer DEFAULT 70,
    isopen boolean DEFAULT TRUE
) RETURNS void
AS $function$
BEGIN

--DELETE FROM Board_HistoryFolder WHERE  UserNo= UserNo;
INSERT INTO Board_HistoryFolder(UserNo,FolderNo,IsOpen)
SELECT   UserNo AS UseNo,BF.FolderNo,IsOpen AS IsOpen 
	FROM Board_Folders   BF
	INNER JOIN Board_HistoryFolder BH ON BH.UserNo=board_setallhistoryfolder.userno AND BH.FolderNo=BF.FolderNo
	WHERE Enabled= TRUE AND BH.HistoryFolderNo IS NULL;
UPDATE Board_HistoryFolder  SET IsOpen=board_setallhistoryfolder.isopen  WHERE  UserNo=board_setallhistoryfolder.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
