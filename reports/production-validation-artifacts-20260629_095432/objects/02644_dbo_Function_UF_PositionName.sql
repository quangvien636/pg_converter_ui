-- ─── FUNCTION: uf_positionname ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_positionname();
CREATE OR REPLACE FUNCTION public.uf_positionname(
) RETURNS character varying
AS $function$
DECLARE
    name character varying;
BEGIN

	-- Declare the return variable here

	SET Name = ''
	-- Add the T-SQL statements to compute the return value here
	SELECT Name = Name || Name || ', ' FROM Organization_Positions 
	WHERE PositionNo IN (SELECT PositionNo 
						FROM Organization_BelongToDepartment 
						WHERE UserNo = UserNo AND Enabled = TRUE)

	-- Return the result of the function
	RETURN Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
