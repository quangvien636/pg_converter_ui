-- ─── FUNCTION: comngetdepartname ───────────────────────────────
DROP FUNCTION IF EXISTS public.comngetdepartname();
CREATE OR REPLACE FUNCTION public.comngetdepartname(
) RETURNS character varying
AS $function$
DECLARE
    departname character varying;
    countdepart integer;
BEGIN

	-- Declare the return variable here


	-- Add the T-SQL statements to compute the return value here
	SELECT DepartName = Name FROM Organization_Departments WHERE DepartNo = DepartNo
	select countDepart=count(*) from Organization_Departments WHERE DepartNo = DepartNo
	if countDepart=0 begin
	
	  select DepartName= Name from Organization_Users where UserNo=DepartNo
	end

	-- Return the result of the function
	RETURN DepartName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
