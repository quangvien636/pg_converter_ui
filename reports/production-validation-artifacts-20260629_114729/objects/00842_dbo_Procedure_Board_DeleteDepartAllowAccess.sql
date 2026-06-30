-- ─── PROCEDURE→FUNCTION: board_deletedepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_deletedepartallowaccess();
CREATE OR REPLACE FUNCTION public.board_deletedepartallowaccess(
) RETURNS void
AS $function$
DECLARE
    departno integer;
    itemno integer;
    itemtype integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	CREATE TEMP TABLE Board_DepartAllowAccess AS SELECT * FROM Board_DepartAllowAccess
	WHERE AllowAccessNo IN(CREATE TEMP TABLE FolderTemp AS SELECT * FROM SplitString(ListAllowAccessNo,','))



	WHILE (Select Count(*) From Board_DepartAllowAccess) > 0 LOOP
		SELECT /* TOP 1 */ DepartNo=DA.DepartNo,ItemNo=DA.ItemNo,ItemType=DA.ItemType FROM Board_DepartAllowAccess DA
		IF(ItemType=2)
		BEGIN;
			DELETE FROM Board_DepartAllowAccess WHERE ItemNo=ItemNo AND ItemType=ItemType AND DepartNo=DepartNo
		END;
		ELSE
			WITH FolderNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =ItemNo
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
			)SELECT * FROM FolderNos;
			DELETE FROM Board_DepartAllowAccess WHERE ItemType=1 AND DepartNo=DepartNo AND
			ItemNo IN (SELECT FolderNo FROM FolderTemp);
			DELETE FROM Board_DepartAllowAccess WHERE ItemType=2 AND DepartNo=DepartNo AND
			ItemNo IN (SELECT BB.BoardNo FROM Board_Boards BB INNER JOIN FolderTemp BF ON BF.FolderNo=bb.FolderNo)
			DROP TABLE FolderTemp
		END IF;;
		DELETE FROM Board_DepartAllowAccess WHERE ItemNo=ItemNo AND ItemType=ItemType AND DepartNo=DepartNo
	END LOOP;
	DROP TABLE Board_DepartAllowAccess;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
