-- ─── FUNCTION: uf_departmentname ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_departmentname();
CREATE OR REPLACE FUNCTION public.uf_departmentname(
) RETURNS character varying
AS $function$
DECLARE
    name character varying;
BEGIN

	-- Declare the return variable here

	SET Name = ''
	-- Add the T-SQL statements to compute the return value here
	/*SELECT Name = REPLACE(Name,Name,'') || Name || ', ' FROM Organization_Departments 
	WHERE DepartNo IN (SELECT DepartNo 
						FROM Organization_BelongToDepartment 
						WHERE UserNo = UserNo AND Enabled = TRUE)*/
	SELECT Name = 
		STUFF ((
		SELECT ',' || NAME FROM Organization_Departments 
		WHERE DepartNo IN (SELECT DepartNo 
	FROM Organization_BelongToDepartment 
	WHERE UserNo = UserNo AND Enabled = TRUE) FOR XML PATH('')
	),1,1,'') 
	-- Return the result of the function
	RETURN Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
