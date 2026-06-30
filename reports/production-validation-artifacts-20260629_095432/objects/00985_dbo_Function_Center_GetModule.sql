-- ─── FUNCTION: center_getmodule ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmodule(integer);
CREATE OR REPLACE FUNCTION public.center_getmodule(
    moduleno integer
) RETURNS TABLE(
    moduleno text,
    code text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	IF (ModuleNo = 0) BEGIN
	
		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		WHERE Code = Code
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		WHERE ModuleNo = center_getmodule.moduleno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
