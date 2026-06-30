-- ─── FUNCTION: dmakesearchtext ───────────────────────────────
DROP FUNCTION IF EXISTS public.dmakesearchtext();
CREATE OR REPLACE FUNCTION public.dmakesearchtext(
) RETURNS character varying
AS $function$
DECLARE
    result character varying;
BEGIN

	-- Declare the return variable here

	-- Add the T-SQL statements to compute the return value here
	SELECT Result = COALESCE(Code,'') FROM DMake_Code
	WHERE ClassNo = ClassNo
	AND (Name ILIKE '%' || SearchText || '%'
	OR Name_EN ILIKE '%' || SearchText || '%'
	OR Name_CH ILIKE '%' || SearchText || '%'
	OR Name_JP ILIKE '%' || SearchText || '%'
	OR Name_VN ILIKE '%' || SearchText || '%')

	-- Return the result of the function
	RETURN Result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
