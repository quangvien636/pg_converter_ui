-- ─── FUNCTION: board_deletedepartallowaccess ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletedepartallowaccess();
CREATE OR REPLACE FUNCTION public.board_deletedepartallowaccess(
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    departno integer;
    itemno integer;
    itemtype integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT * 
	INTO   #Board_DepartAllowAccess
	FROM Board_DepartAllowAccess
	WHERE AllowAccessNo IN(SELECT * FROM SplitString(ListAllowAccessNo,','))



	WHILE (Select Count(*) From #Board_DepartAllowAccess) > 0
	BEGIN
		SELECT /* TOP 1 */ DepartNo=DA.DepartNo,ItemNo=DA.ItemNo,ItemType=DA.ItemType FROM #Board_DepartAllowAccess DA
		IF(ItemType=2)
		BEGIN;
			DELETE FROM Board_DepartAllowAccess WHERE ItemNo=ItemNo AND ItemType=ItemType AND DepartNo=DepartNo
		END
		ELSE
		BEGIN
			WITH FolderNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =ItemNo
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
			)SELECT * INTO   #FolderTemp FROM FolderNos;
			DELETE FROM Board_DepartAllowAccess WHERE ItemType=1 AND DepartNo=DepartNo AND
			ItemNo IN (SELECT FolderNo FROM #FolderTemp);
			DELETE FROM Board_DepartAllowAccess WHERE ItemType=2 AND DepartNo=DepartNo AND
			ItemNo IN (SELECT BB.BoardNo FROM Board_Boards BB INNER JOIN #FolderTemp BF ON BF.FolderNo=bb.FolderNo)
			DROP TABLE #FolderTemp
		END;
		DELETE FROM #Board_DepartAllowAccess WHERE ItemNo=ItemNo AND ItemType=ItemType AND DepartNo=DepartNo
	END
	DROP TABLE #Board_DepartAllowAccess;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
