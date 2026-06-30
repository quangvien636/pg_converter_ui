-- ─── FUNCTION: comngetparentdepartname ───────────────────────────────
DROP FUNCTION IF EXISTS public.comngetparentdepartname();
CREATE OR REPLACE FUNCTION public.comngetparentdepartname(
) RETURNS character varying
AS $function$
DECLARE
    departname character varying;
    tempname character varying;
    cnt integer;
BEGIN

	-- Declare the return variable here



	SELECT TempName = Name FROM Organization_Departments WHERE DepartNo = DepartNo
	
	SELECT CNT = COUNT(Name) FROM Organization_Departments WHERE Name = TempName;

	-- Add the T-SQL statements to compute the return value here
	SELECT DepartName = Name FROM Organization_Departments
	WHERE DepartNo = (SELECT ParentNo FROM Organization_Departments WHERE DepartNo = DepartNo)
	
	IF CNT = 1 
	BEGIN
		SET DepartName = '';	
	END

	-- Return the result of the function
	RETURN DepartName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
