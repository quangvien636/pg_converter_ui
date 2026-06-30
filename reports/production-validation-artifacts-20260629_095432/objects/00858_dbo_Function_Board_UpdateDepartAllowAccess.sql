-- ─── FUNCTION: board_updatedepartallowaccess ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatedepartallowaccess(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_updatedepartallowaccess(
    departno integer DEFAULT 4,
    allowvalue integer DEFAULT 2,
    itemno integer DEFAULT 1160,
    itemtype integer DEFAULT 2,
    userno integer DEFAULT 70
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    no bigint;
    value integer;
    folderno integer;
    prentaccessno bigint;
    parentvalue integer;
    folderno1 integer;
    no1 bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--UPDATE Board_DepartAllowAccess SET DepartNo=DepartNo,AllowValue=AllowValue , ItemNo=ItemNo,ItemType=ItemType,ModUserNo=UserNo,ModDate=NOW()
	--WHERE AllowAccessNo=AllowAccessNo
	--SELECT AllowAccessNo

	IF(ItemType=2)
	BEGIN;
		DELETE FROM Board_DepartAllowAccess
		WHERE DepartNo = board_updatedepartallowaccess.departno AND ItemNo=board_updatedepartallowaccess.itemno AND ItemType= board_updatedepartallowaccess.itemtype
		IF (AllowValue >0 )
		BEGIN;
			INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
			VALUES(DepartNo,AllowValue,ItemNo,ItemType,UserNo,NOW(),UserNo,NOW());	 
			WITH FolderNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updatedepartallowaccess.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			RETURN QUERY
			SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo
			INTO   #FolderTemp1
			FROM FolderNos F
			LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno



			WHILE (Select Count(*) From #FolderTemp1) > 0
			BEGIN
				RETURN QUERY
				Select /* TOP 1 */ No = AllowAccessNo,Value=board_updatedepartallowaccess.allowvalue,FolderNo=FolderNo From #FolderTemp1
				IF (AllowValue >0 )
				BEGIN
					IF(No=0)
					BEGIN;
						INSERT INTO  public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						RETURN QUERY
						SELECT /* TOP 1 */ DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM #FolderTemp1 FT
				
					END
					ELSE BEGIN 
						IF(AllowValue>Value)
						BEGIN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno WHERE AllowAccessNo=No
						END
					END
 				
				END
				Delete #FolderTemp1 Where FolderNo = FolderNo

			END
		END
		
	END
	ELSE BEGIN
		WITH FolderParentNos AS
			(
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updatedepartallowaccess.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
		RETURN QUERY
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo
		INTO   #FolderParentTemp
		FROM FolderParentNos F
		LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno



		WHILE (Select Count(*) From #FolderParentTemp) > 0
		BEGIN
			
			RETURN QUERY
			Select /* TOP 1 */ PrentAccessNo = AllowAccessNo,ParentValue=board_updatedepartallowaccess.allowvalue,FolderNo1=FolderNo From #FolderParentTemp
				IF (AllowValue >0 )
				BEGIN
					IF(PrentAccessNo=0)
					BEGIN;
						INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						RETURN QUERY
						SELECT /* TOP 1 */ DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM #FolderParentTemp FT
				
					END
					ELSE BEGIN 
						--IF(AllowValue>Value)

						IF(AllowValue>ParentValue)
						BEGIN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo
						END
					END
 				
				END
				Delete #FolderParentTemp Where FolderNo = FolderNo1
		END;
		WITH FolderNos AS
		(
			SELECT     PF.FolderNo 
			FROM       Board_Folders PF
			WHERE PF.FolderNo=board_updatedepartallowaccess.itemno AND PF.Enabled = TRUE
			UNION ALL
			SELECT     CF.FolderNo
			FROM       Board_Folders CF
			INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
		)
		---List FolderNo
		RETURN QUERY
		SELECT FolderNo
		INTO   #FolderTemp
		FROM FolderNos
		----List BoardNo
		RETURN QUERY
		SELECT BoardNo
		INTO   #BoardTemp
		FROM Board_Boards
		WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM #FolderTemp)

		WHILE (Select Count(*) From #FolderTemp) > 0
		BEGIN
			RETURN QUERY
			Select /* TOP 1 */ No1 = FolderNo From #FolderTemp
			IF (AllowValue >=0 )
			BEGIN
				IF((SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno)>0)
				BEGIN
					--Print No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno
				END
				ELSE BEGIN;
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW())
				END

			END

			Delete #FolderTemp Where FolderNo = No1

		END
		WHILE (Select Count(*) From #BoardTemp) > 0
		BEGIN
			RETURN QUERY
			SELECT /* TOP 1 */ No1 = BoardNo From #BoardTemp
			--Print AllowValue
			--DELETE FROM Board_DepartAllowAccess
			--WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
			IF (AllowValue >=0 )	
			BEGIN
				IF((SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno )>0)
				BEGIN
					--Print  No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW()  WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno
				END
				ELSE BEGIN;
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,2,UserNo,NOW(),UserNo,NOW())
				END
			END
			Delete #BoardTemp Where BoardNo = No1
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
