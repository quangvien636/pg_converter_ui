-- ─── PROCEDURE→FUNCTION: contacts_deletedepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_deletedepartallowaccess(character varying);
CREATE OR REPLACE FUNCTION public.contacts_deletedepartallowaccess(
    IN listallowaccessno character varying
) RETURNS void
AS $function$
DECLARE
    departno integer;
    itemno integer;
BEGIN


	CREATE TEMP TABLE Contact_DepartAllowAccess AS SELECT * FROM Contact_DepartAllowAccess
	WHERE AllowAccessNo IN(CREATE TEMP TABLE ShareGroupTemp AS SELECT * FROM SplitString(ListAllowAccessNo,','));



	WHILE (Select Count(*) From Contact_DepartAllowAccess) > 0 LOOP
			SELECT DA.DepartNo, DA.ItemNo INTO departno, itemno FROM Contact_DepartAllowAccess DA
			WITH RECURSIVE ShareGroupNos AS (
				SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       Contact_ShareGroup PF

				WHERE PF.ShareGroupNo =ItemNo
				UNION ALL
				SELECT     CF.ShareGroupNo , CF.ParentNo
				FROM       Contact_ShareGroup CF
				INNER JOIN ShareGroupNos FN ON FN.ShareGroupNo = CF.ParentNo AND CF.IsDelete = FALSE
			)
			SELECT * FROM ShareGroupNos;

			DELETE FROM Contact_DepartAllowAccess WHERE DepartNo=DepartNo AND ItemNo IN (SELECT BB.ShareGroupNo FROM Contact_ShareGroup BB INNER JOIN ShareGroupTemp BF ON BF.ShareGroupNo=bb.ShareGroupNo);

			DROP TABLE ShareGroupTemp;

			DELETE FROM Contact_DepartAllowAccess WHERE ItemNo=ItemNo AND  DepartNo=DepartNo;
	END LOOP;
	DROP TABLE Contact_DepartAllowAccess;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.