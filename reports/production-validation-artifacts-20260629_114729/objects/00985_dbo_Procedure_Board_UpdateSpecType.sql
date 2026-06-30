-- ─── PROCEDURE→FUNCTION: board_updatespectype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updatespectype(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_updatespectype(
    IN itemno integer DEFAULT 111,
    IN itemtype integer DEFAULT 1,
    IN specvalue integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF(ItemType=2)
	BEGIN ;
		UPDATE Board_Boards
		SpecType := board_updatespectype.specvalue;
		WHERE  ItemNo=BoardNo
		IF(SpecValue=1)
		BEGIN 
			WITH FolderNos AS
			(
				CREATE TEMP TABLE FolderTemp1 AS SELECT PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updatespectype.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			SELECT FolderNo FROM FolderNos;
			UPDATE Board_Folders
			SpecType := board_updatespectype.specvalue;
			WHERE  FolderNo IN (CREATE TEMP TABLE FolderTemp AS SELECT FolderNo FROM FolderTemp1)
		END;
	END;
	ELSE BEGIN;
		UPDATE Board_Folders
		SpecType := board_updatespectype.specvalue;
		WHERE FolderNo=board_updatespectype.itemno 
		---List FolderNo
		IF(SpecValue=0)
		BEGIN
			WITH FolderNos AS
			(
				SELECT     PF.FolderNo 
				FROM       Board_Folders PF
				WHERE PF.FolderNo=board_updatespectype.itemno AND PF.Enabled = TRUE
				UNION ALL
				SELECT     CF.FolderNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
			)
			SELECT FolderNo FROM FolderNos
			----List BoardNo
			CREATE TEMP TABLE BoardTemp AS SELECT BoardNo FROM Board_Boards
			WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp);
			UPDATE Board_Folders
			SpecType := board_updatespectype.specvalue;
			WHERE FolderNo<>board_updatespectype.itemno AND  FolderNo IN (SELECT FolderNo FROM FolderTemp);
			DELETE FROM FolderTemp ;
			UPDATE Board_Boards
			SpecType := board_updatespectype.specvalue;
			WHERE  BoardNo IN (SELECT BoardNo FROM BoardTemp);
			DELETE FROM BoardTemp 
		END;
		ELSE BEGIN
			WITH FolderParentNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updatespectype.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			);
			UPDATE Board_Folders
			SpecType := board_updatespectype.specvalue;
			WHERE FolderNo<>board_updatespectype.itemno AND  FolderNo IN (SELECT FolderNo FROM FolderParentNos)
		END;
	END;
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
