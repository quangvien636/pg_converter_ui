-- ─── FUNCTION: dmakegetclassno ───────────────────────────────
DROP FUNCTION IF EXISTS public.dmakegetclassno();
CREATE OR REPLACE FUNCTION public.dmakegetclassno(
) RETURNS integer
AS $function$
DECLARE
    classno integer;
BEGIN

	-- Declare the return variable here

	-- Add the T-SQL statements to compute the return value here
	SELECT ClassNo = COALESCE(ClassNo,0) FROM DMake_Boards_Fields
	WHERE BoardNo = BoardNo
	AND FieldName = FieldName

	-- Return the result of the function
	RETURN ClassNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
