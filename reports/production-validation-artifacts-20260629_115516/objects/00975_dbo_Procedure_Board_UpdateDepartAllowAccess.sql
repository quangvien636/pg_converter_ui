-- ─── PROCEDURE→FUNCTION: board_updatedepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_updatedepartallowaccess(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_updatedepartallowaccess(
    IN departno integer DEFAULT 4,
    IN allowvalue integer DEFAULT 2,
    IN itemno integer DEFAULT 1160,
    IN itemtype integer DEFAULT 2,
    IN userno integer DEFAULT 70
) RETURNS SETOF record
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
	--CREATE TEMP TABLE FolderTemp1 AS SELECT AllowAccessNo

	IF(ItemType=2)
	BEGIN;
		DELETE FROM Board_DepartAllowAccess
		WHERE DepartNo = board_updatedepartallowaccess.departno AND ItemNo=board_updatedepartallowaccess.itemno AND ItemType= board_updatedepartallowaccess.itemtype
		IF AllowValue >0 THEN;
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
			SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderNos F
			LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno



			WHILE (CREATE TEMP TABLE FolderParentTemp AS SELECT Count(*) From FolderTemp1) > 0 LOOP
				RETURN QUERY
				Select /* TOP 1 */ No = AllowAccessNo,Value=board_updatedepartallowaccess.allowvalue,FolderNo=FolderNo From FolderTemp1
				IF AllowValue >0 THEN
					IF(No=0)
					BEGIN;
						INSERT INTO  public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						RETURN QUERY
						SELECT /* TOP 1 */ DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM FolderTemp1 FT
				
					END;
					ELSE BEGIN 
						IF(AllowValue>Value)
						BEGIN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno WHERE AllowAccessNo=No
						END;
					END IF;
 				
				END LOOP;;
				DELETE FROM FolderTemp1 Where FolderNo = FolderNo

			END IF;
		END;
		
	END;
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
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderParentNos F
		LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno



		WHILE (CREATE TEMP TABLE FolderTemp AS SELECT Count(*) From FolderParentTemp) > 0 LOOP
			
			RETURN QUERY
			Select /* TOP 1 */ PrentAccessNo = AllowAccessNo,ParentValue=board_updatedepartallowaccess.allowvalue,FolderNo1=FolderNo From FolderParentTemp
				IF AllowValue >0 THEN
					IF(PrentAccessNo=0)
					BEGIN;
						INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						RETURN QUERY
						SELECT /* TOP 1 */ DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM FolderParentTemp FT
				
					END;
					ELSE BEGIN 
						--IF(AllowValue>Value)

						IF(AllowValue>ParentValue)
						BEGIN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo
						END;
					END IF;
 				
				END LOOP;;
				DELETE FROM FolderParentTemp Where FolderNo = FolderNo1
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
		SELECT FolderNo FROM FolderNos
		----List BoardNo
		CREATE TEMP TABLE BoardTemp AS SELECT BoardNo FROM Board_Boards
		WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp)

		WHILE (Select Count(*) From FolderTemp) > 0 LOOP
			RETURN QUERY
			Select /* TOP 1 */ No1 = FolderNo From FolderTemp
			IF AllowValue >=0 THEN
				IF((SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno)>0)
				BEGIN
					--Print No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno
				END;
				ELSE BEGIN;
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW())
				END IF;

			END LOOP;

			DELETE FROM FolderTemp Where FolderNo = No1

		END;
		WHILE (Select Count(*) From BoardTemp) > 0 LOOP
			RETURN QUERY
			SELECT /* TOP 1 */ No1 = BoardNo From BoardTemp
			--Print AllowValue
			--DELETE FROM Board_DepartAllowAccess
			--WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
			IF AllowValue >=0 THEN
				IF((SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno )>0)
				BEGIN
					--Print  No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW()  WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno
				END;
				ELSE BEGIN;
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,2,UserNo,NOW(),UserNo,NOW())
				END IF;
			END LOOP;;
			DELETE FROM BoardTemp Where BoardNo = No1
		END;
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
