-- ─── FUNCTION: uf_positionname_en ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_positionname_en();
CREATE OR REPLACE FUNCTION public.uf_positionname_en(
) RETURNS character varying
AS $function$
DECLARE
    name character varying;
BEGIN

	-- Declare the return variable here

	SET Name = ''
	-- Add the T-SQL statements to compute the return value here
	SELECT Name = Name || Name_EN || ', ' FROM Organization_Positions 
	WHERE PositionNo IN (SELECT PositionNo 
						FROM Organization_BelongToDepartment 
						WHERE UserNo = UserNo AND Enabled = TRUE)

	-- Return the result of the function
	RETURN Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
