-- ─── FUNCTION: organization_getdepartmentschildbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartmentschildbyuser(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentschildbyuser(
    userno integer
) RETURNS TABLE(
    departno integer
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
#variable_conflict use_column
DECLARE
    tb_temp table(
			departno int
		);
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		INSERT INTO TB_TEMP SELECT DepartNo FROM  Organization_BelongToDepartment where UserNo = organization_getdepartmentschildbyuser.userno

		WHILE EXISTS(SELECT * FROM TB_TEMP)
		BEGIN
			SET DepartNo = (SELECT /* TOP 1 */ DepartNo FROM TB_TEMP)
			
			IF(DepartNo IS NULL)
			BEGIN;
				DELETE FROM TB_TEMP
				BREAK;
			END
			--INSERT INTO ListOfDepartNos VALUES(DepartNo);
			INSERT INTO ListOfDepartNos  SELECT DepartNo FROM  Organization_GetDepartments_Reflexive(DepartNo,0);
			DELETE FROM TB_TEMP WHERE DepartNo = DepartNo
		END

	


	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
