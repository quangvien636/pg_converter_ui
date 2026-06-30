-- ─── FUNCTION: contacts_updatedepartallowaccess ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatedepartallowaccess(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatedepartallowaccess(
    departno integer DEFAULT 4,
    allowvalue integer DEFAULT 2,
    itemno integer DEFAULT 16,
    userno integer DEFAULT 70
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    prentaccessno bigint;
    parentvalue integer;
    sharegroupno1 integer;
    no1 bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--UPDATE Contacts_DepartAllowAccess SET DepartNo=DepartNo,AllowValue=AllowValue , ItemNo=ItemNo,ItemType=ItemType,ModUserNo=UserNo,ModDate=NOW()
	--WHERE AllowAccessNo=AllowAccessNo
	--SELECT AllowAccessNo


		WITH GroupTmp AS
		(
				SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       Contact_ShareGroup PF

				WHERE PF.ShareGroupNo =contacts_updatedepartallowaccess.itemno
				UNION ALL
				SELECT     CF.ShareGroupNo , CF.ParentNo
				FROM       Contact_ShareGroup CF
				INNER JOIN GroupTmp FN ON FN.ParentNo = CF.ShareGroupNo AND CF.IsDelete = FALSE
			
		),GroupParentNos AS(
			SELECT 0 AS ShareGroupNo,-1 AS ParentNo
			UNION ALL
			SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       GroupTmp PF
		)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.ShareGroupNo
		INTO   #FolderParentTemp
		FROM GroupParentNos F
		LEFT JOIN Contact_DepartAllowAccess BA ON BA.ItemNo=F.ShareGroupNo AND BA.DepartNo=contacts_updatedepartallowaccess.departno



		WHILE (Select Count(*) From #FolderParentTemp) > 0
		BEGIN
			
			Select /* TOP 1 */ PrentAccessNo = AllowAccessNo,ParentValue=contacts_updatedepartallowaccess.allowvalue,ShareGroupNo1=ShareGroupNo From #FolderParentTemp
				IF (AllowValue >0 )
				BEGIN
					IF(PrentAccessNo=0)
					BEGIN;
						INSERT INTO public."Contact_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT /* TOP 1 */ DepartNo,AllowValue,FT.ShareGroupNo,UserNo,NOW(),UserNo,NOW() FROM #FolderParentTemp FT
				
					END
					ELSE BEGIN 
						--IF(AllowValue>Value)

						IF(AllowValue>ParentValue)
						BEGIN

							UPDATE Contact_DepartAllowAccess SET AllowValue=contacts_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=contacts_updatedepartallowaccess.departno,ModUserNo=contacts_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo
						END
					END
 				
				END
				Delete #FolderParentTemp Where ShareGroupNo = ShareGroupNo1
		END;
				WITH ShareGroupNos AS
		(
			SELECT     PF.ShareGroupNo 
			FROM       Contact_ShareGroup PF
			WHERE PF.ShareGroupNo=contacts_updatedepartallowaccess.itemno AND PF.IsDelete = FALSE
			UNION ALL
			SELECT     CF.ShareGroupNo
			FROM       Contact_ShareGroup CF
			INNER JOIN ShareGroupNos FN ON FN.ShareGroupNo = CF.ParentNo AND CF.IsDelete = FALSE
		)
		---List ShareGroupNo
		SELECT ShareGroupNo
		INTO   #GroupTemp
		FROM ShareGroupNos
		----List BoardNo

		WHILE (Select Count(*) From #GroupTemp) > 0
		BEGIN
			Select /* TOP 1 */ No1 = ShareGroupNo From #GroupTemp
			IF (AllowValue >=0 )
			BEGIN
				IF((SELECT COUNT(AllowAccessNo) FROM Contact_DepartAllowAccess WHERE  ItemNo=No1 AND DepartNo=contacts_updatedepartallowaccess.departno)>0)
				BEGIN
					--Print No1;
					UPDATE Contact_DepartAllowAccess SET AllowValue=contacts_updatedepartallowaccess.allowvalue,DepartNo=contacts_updatedepartallowaccess.departno,ModUserNo=contacts_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemNo=No1 AND DepartNo=contacts_updatedepartallowaccess.departno
				END
				ELSE BEGIN;
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW())
				END

			END

			Delete #GroupTemp Where ShareGroupNo = No1

		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
