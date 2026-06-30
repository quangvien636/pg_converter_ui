-- ─── PROCEDURE→FUNCTION: board_updateallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateallowaccess(integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_updateallowaccess(
    IN departno integer DEFAULT 49,
    IN positionno integer DEFAULT 23,
    IN userno integer DEFAULT 6656,
    IN allowvalue integer DEFAULT 2,
    IN itemno integer DEFAULT 137,
    IN itemtype integer DEFAULT 1
) RETURNS void
AS $function$
DECLARE
    no bigint;
    value integer;
    folderno integer;
    prentaccessno bigint;
    parentvalue integer;
    folderno1 integer;
    no1 bigint;
BEGIN

	IF ItemType=2 THEN
		DELETE FROM Board_AllowAccess
		WHERE UserNo = board_updateallowaccess.userno AND ItemNo=board_updateallowaccess.itemno AND ItemType= board_updateallowaccess.itemtype; -- AND DepartNo=DepartNo AND PositionNo= PositionNo 
		IF AllowValue >0 THEN
			INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
			VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,NOW(),NOW());	 
			CREATE TEMP TABLE FolderTemp1 ON COMMIT DROP AS WITH FolderNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updateallowaccess.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderNos F
			LEFT JOIN Board_AllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.UserNo=board_updateallowaccess.userno;



			WHILE (Select Count(*) From FolderTemp1) > 0 LOOP
				SELECT AllowAccessNo, AllowValue, FolderNo INTO no, value, folderno FROM FolderTemp1;
				IF AllowValue >0 THEN
					IF No=0 THEN
						INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
						SELECT DepartNo,PositionNo,UserNo,AllowValue,FT.FolderNo,1,NOW(),NOW() FROM FolderTemp1 FT;
				
					ELSE
						IF AllowValue>Value THEN
							RAISE NOTICE '%', No;
							UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno WHERE AllowAccessNo=No;
						END IF;
					END IF;
 				
				END IF;
				DELETE FROM FolderTemp1 Where FolderNo = FolderNo;;

			END LOOP;
		END IF;
		
	ELSE
		CREATE TEMP TABLE FolderParentTemp ON COMMIT DROP AS WITH FolderParentNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updateallowaccess.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderParentNos F
		LEFT JOIN Board_AllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.UserNo=board_updateallowaccess.userno;



		WHILE (Select Count(*) From FolderParentTemp) > 0 LOOP
			
			SELECT AllowAccessNo, AllowValue, FolderNo INTO prentaccessno, parentvalue, folderno1 FROM FolderParentTemp;
				IF AllowValue >0 THEN
					IF PrentAccessNo=0 THEN
						INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
						SELECT DepartNo,PositionNo,UserNo,AllowValue,FT.FolderNo,1,NOW(),NOW() FROM FolderParentTemp FT;
				
					ELSE
						--IF(AllowValue>Value)

						IF AllowValue>ParentValue THEN
							RAISE NOTICE '%', No;
							UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno WHERE AllowAccessNo=PrentAccessNo;
						END IF;
					END IF;
 				
				END IF;
				DELETE FROM FolderParentTemp Where FolderNo = FolderNo1;;
		END LOOP;
		CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH FolderNos AS
		(
			SELECT     PF.FolderNo 
			FROM       Board_Folders PF
			WHERE PF.FolderNo=board_updateallowaccess.itemno AND PF.Enabled = TRUE
			UNION ALL
			SELECT     CF.FolderNo
			FROM       Board_Folders CF
			INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
		)
		---List FolderNo
		SELECT FolderNo FROM FolderNos;
		----List BoardNo
		CREATE TEMP TABLE BoardTemp ON COMMIT DROP AS SELECT BoardNo FROM Board_Boards
		WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp);

		WHILE (Select Count(*) From FolderTemp) > 0 LOOP
			SELECT FolderNo INTO no1 FROM FolderTemp;
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_AllowAccess WHERE ItemType=1 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue)>0 THEN
					RAISE NOTICE '%', No1;
					UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno ,ModDate=NOW() WHERE ItemType=1 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue;
				END IF;
			END IF;

			DELETE FROM FolderTemp Where FolderNo = No1;;

		END LOOP;
		WHILE (Select Count(*) From BoardTemp) > 0 LOOP
			SELECT BoardNo INTO no1 FROM BoardTemp;
			--Print AllowValue
			--DELETE FROM Board_AllowAccess
			--WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_AllowAccess WHERE ItemType=2 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue)>0 THEN
					RAISE NOTICE '%', No1;
					UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno,ModDate=NOW()  WHERE ItemType=2 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue;
				END IF;
			END IF;
			DELETE FROM BoardTemp Where BoardNo = No1;;
		END LOOP;
	END IF;

	--IF(ItemType=2)
	--BEGIN
	--	DELETE FROM Board_AllowAccess
	--	WHERE UserNo = UserNo AND ItemNo=ItemNo AND ItemType= ItemType-- AND DepartNo=DepartNo AND PositionNo= PositionNo 
	--	IF (AllowValue >0 )
	--	BEGIN
	--		INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
	--		VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,NOW(),NOW())	 
	--	END
	--END
	--ELSE BEGIN
	--	WITH FolderNos AS
	--	(
	--		SELECT     PF.FolderNo 
	--		FROM       Board_Folders PF
	--		WHERE PF.FolderNo=ItemNo AND PF.Enabled = TRUE
	--		UNION ALL
	--		SELECT     CF.FolderNo
	--		FROM       Board_Folders CF
	--		INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
	--	)
	--	---List FolderNo
	--	SELECT FolderNo
	--	INTO   FolderTemp
	--	FROM FolderNos
	--	----List BoardNo
	--	SELECT BoardNo
	--	INTO   BoardTemp
	--	FROM Board_Boards
	--	WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp)
	--	Declare No BIGINT
	--	WHILE (Select Count(*) From FolderTemp) > 0
	--	BEGIN
	--		SELECT FolderNo INTO no From FolderTemp
	--		Print AllowValue
	--		DELETE FROM Board_AllowAccess
	--		WHERE UserNo = UserNo  AND ItemNo=No AND ItemType= 1
	--		IF (AllowValue >0 )
	--		BEGIN
	--			INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
	--			VALUES(DepartNo,PositionNo,UserNo,AllowValue,No,1,NOW(),NOW())
	--		END

	--		DELETE FROM FolderTemp Where FolderNo = No

	--	END
	--	WHILE (Select Count(*) From BoardTemp) > 0
	--	BEGIN
	--		SELECT BoardNo INTO no From BoardTemp
	--		Print AllowValue
	--		DELETE FROM Board_AllowAccess
	--		WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
	--		IF (AllowValue >0 )	
	--		BEGIN
	--			INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
	--			VALUES(DepartNo,PositionNo,UserNo,AllowValue,No,2,NOW(),NOW())
	--		END
	--		DELETE FROM BoardTemp Where BoardNo = No
	--	END
	--END
	SELECT ItemNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.