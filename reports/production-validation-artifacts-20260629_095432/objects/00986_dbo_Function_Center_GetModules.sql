-- ─── FUNCTION: center_getmodules ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmodules(boolean);
CREATE OR REPLACE FUNCTION public.center_getmodules(
    alsodisabled boolean
) RETURNS TABLE(
    moduleno text,
    code text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	IF AlsoDisabled = 1 BEGIN

		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		ORDER BY SortNo
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		WHERE Enabled = TRUE
		ORDER BY SortNo
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
