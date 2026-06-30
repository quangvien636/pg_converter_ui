-- ─── PROCEDURE→FUNCTION: board_updatedepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
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
	--SELECT AllowAccessNo

	IF ItemType=2 THEN
		DELETE FROM Board_DepartAllowAccess
		WHERE DepartNo = board_updatedepartallowaccess.departno AND ItemNo=board_updatedepartallowaccess.itemno AND ItemType= board_updatedepartallowaccess.itemtype;
		IF AllowValue >0 THEN
			INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
			VALUES(DepartNo,AllowValue,ItemNo,ItemType,UserNo,NOW(),UserNo,NOW());
			CREATE TEMP TABLE FolderTemp1 ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updatedepartallowaccess.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderNos F
			LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno;



			WHILE (Select Count(*) From FolderTemp1) > 0 LOOP
				SELECT AllowAccessNo, AllowValue, FolderNo INTO no, value, folderno FROM FolderTemp1;
				IF AllowValue >0 THEN
					IF No=0 THEN
						INSERT INTO  public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM FolderTemp1 FT;

					ELSE
						IF AllowValue>Value THEN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno WHERE AllowAccessNo=No;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderTemp1 Where FolderNo = FolderNo;

			END LOOP;
		END IF;

	ELSE
		CREATE TEMP TABLE FolderParentTemp ON COMMIT DROP AS WITH RECURSIVE FolderParentNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updatedepartallowaccess.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderParentNos F
		LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno;



		WHILE (Select Count(*) From FolderParentTemp) > 0 LOOP

			SELECT AllowAccessNo, AllowValue, FolderNo INTO prentaccessno, parentvalue, folderno1 FROM FolderParentTemp;
				IF AllowValue >0 THEN
					IF PrentAccessNo=0 THEN
						INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM FolderParentTemp FT;

					ELSE
						--IF(AllowValue>Value)

						IF AllowValue>ParentValue THEN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderParentTemp Where FolderNo = FolderNo1;
		END LOOP;
		CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
			SELECT     PF.FolderNo
			FROM       Board_Folders PF
			WHERE PF.FolderNo=board_updatedepartallowaccess.itemno AND PF.Enabled = TRUE
			UNION ALL
			SELECT     CF.FolderNo
			FROM       Board_Folders CF
			INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
		)
		---List FolderNo;
		RETURN QUERY
		SELECT FolderNo FROM FolderNos;
		----List BoardNo
		CREATE TEMP TABLE BoardTemp ON COMMIT DROP AS SELECT BoardNo FROM Board_Boards
		WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp);

		WHILE (Select Count(*) From FolderTemp) > 0 LOOP
			SELECT FolderNo INTO no1 FROM FolderTemp;
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno)>0 THEN
					--Print No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno;
				ELSE
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW());
				END IF;

			END IF;

			DELETE FROM FolderTemp Where FolderNo = No1;

		END LOOP;
		WHILE (Select Count(*) From BoardTemp) > 0 LOOP
			SELECT BoardNo INTO no1 FROM BoardTemp;
			--Print AllowValue
			--DELETE FROM Board_DepartAllowAccess
			--WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno )>0 THEN
					--Print  No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW()  WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno;
				ELSE
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,2,UserNo,NOW(),UserNo,NOW());
				END IF;
			END IF;
			DELETE FROM BoardTemp Where BoardNo = No1;
		END LOOP;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.