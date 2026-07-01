-- ─── PROCEDURE→FUNCTION: contacts_updatedepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatedepartallowaccess(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatedepartallowaccess(
    IN departno integer DEFAULT 4,
    IN allowvalue integer DEFAULT 2,
    IN itemno integer DEFAULT 16,
    IN userno integer DEFAULT 70
) RETURNS void
AS $function$
DECLARE
    prentaccessno bigint;
    parentvalue integer;
    sharegroupno1 integer;
    no1 bigint;
BEGIN


	--UPDATE Contacts_DepartAllowAccess SET DepartNo=DepartNo,AllowValue=AllowValue , ItemNo=ItemNo,ItemType=ItemType,ModUserNo=UserNo,ModDate=NOW()
	--WHERE AllowAccessNo=AllowAccessNo
	--SELECT AllowAccessNo


		CREATE TEMP TABLE FolderParentTemp ON COMMIT DROP AS WITH RECURSIVE GroupTmp AS (
				SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       Contact_ShareGroup PF

				WHERE PF.ShareGroupNo =contacts_updatedepartallowaccess.itemno
				UNION ALL;
				SELECT     CF.ShareGroupNo , CF.ParentNo
				FROM       Contact_ShareGroup CF
				INNER JOIN GroupTmp FN ON FN.ParentNo = CF.ShareGroupNo AND CF.IsDelete = FALSE

		),GroupParentNos AS(
			SELECT 0 AS ShareGroupNo,-1 AS ParentNo
			UNION ALL
			SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       GroupTmp PF
		)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.ShareGroupNo FROM GroupParentNos F
		LEFT JOIN Contact_DepartAllowAccess BA ON BA.ItemNo=F.ShareGroupNo AND BA.DepartNo=contacts_updatedepartallowaccess.departno;



		WHILE (Select Count(*) From FolderParentTemp) > 0 LOOP

			SELECT AllowAccessNo, AllowValue, ShareGroupNo INTO prentaccessno, parentvalue, sharegroupno1 FROM FolderParentTemp;
				IF AllowValue >0 THEN
					IF PrentAccessNo=0 THEN
						INSERT INTO public."Contact_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT DepartNo,AllowValue,FT.ShareGroupNo,UserNo,NOW(),UserNo,NOW() FROM FolderParentTemp FT;

					ELSE
						--IF(AllowValue>Value)

						IF AllowValue>ParentValue THEN

							UPDATE Contact_DepartAllowAccess SET AllowValue=contacts_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=contacts_updatedepartallowaccess.departno,ModUserNo=contacts_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderParentTemp Where ShareGroupNo = ShareGroupNo1;
		END LOOP;
		CREATE TEMP TABLE GroupTemp ON COMMIT DROP AS WITH RECURSIVE ShareGroupNos AS (
			SELECT     PF.ShareGroupNo
			FROM       Contact_ShareGroup PF
			WHERE PF.ShareGroupNo=contacts_updatedepartallowaccess.itemno AND PF.IsDelete = FALSE
			UNION ALL;
			SELECT     CF.ShareGroupNo
			FROM       Contact_ShareGroup CF
			INNER JOIN ShareGroupNos FN ON FN.ShareGroupNo = CF.ParentNo AND CF.IsDelete = FALSE
		)
		---List ShareGroupNo
		SELECT ShareGroupNo FROM ShareGroupNos;
		----List BoardNo

		WHILE (Select Count(*) From GroupTemp) > 0 LOOP
			SELECT ShareGroupNo INTO no1 FROM GroupTemp;
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Contact_DepartAllowAccess WHERE  ItemNo=No1 AND DepartNo=contacts_updatedepartallowaccess.departno)>0 THEN
					--Print No1;
					UPDATE Contact_DepartAllowAccess SET AllowValue=contacts_updatedepartallowaccess.allowvalue,DepartNo=contacts_updatedepartallowaccess.departno,ModUserNo=contacts_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemNo=No1 AND DepartNo=contacts_updatedepartallowaccess.departno;
				ELSE
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW());
				END IF;

			END IF;

			DELETE FROM GroupTemp Where ShareGroupNo = No1;

		END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.