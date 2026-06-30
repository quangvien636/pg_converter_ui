-- ─── FUNCTION: organization_getdepartments_reflexive ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartments_reflexive(integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_getdepartments_reflexive(
    departno integer,
    alsodisabled boolean
) RETURNS TABLE(
    departno integer
)
AS $function$
#variable_conflict use_column
BEGIN


	INSERT INTO ReturnDepartments VALUES (DepartNo)
	

		RowNum	INT IDENTITY (1, 1),
		DepartNo	INT
	)
	
	IF (AlsoDisabled = 1) BEGIN
	
		INSERT INTO _Departments
		RETURN QUERY
		SELECT DepartNo FROM Organization_Departments
		WHERE ParentNo = organization_getdepartments_reflexive.departno
		
	END
	
	ELSE BEGIN
	
		INSERT INTO _Departments
		RETURN QUERY
		SELECT DepartNo FROM Organization_Departments
		WHERE ParentNo = organization_getdepartments_reflexive.departno AND Enabled = TRUE
		
	END
	

	SET RowCount = (SELECT COUNT(*) FROM _Departments)
	SET CurrentNum = 1
	
	WHILE (CurrentNum <= RowCount) BEGIN
	
		SET _DepartNo = (SELECT DepartNo FROM _Departments WHERE RowNum = CurrentNum)
	
		INSERT INTO ReturnDepartments
		RETURN QUERY
		SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(_DepartNo, AlsoDisabled)
		
		SET CurrentNum = CurrentNum + 1
		
	END
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
