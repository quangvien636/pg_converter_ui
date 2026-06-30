-- ─── FUNCTION: approval_getformcategories ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getformcategories(boolean);
CREATE OR REPLACE FUNCTION public.approval_getformcategories(
    alsodisabled boolean
) RETURNS TABLE(
    categoryno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    parentno text,
    name text,
    enabled text
)
AS $function$
BEGIN


	IF AlsoDisabled = 1 BEGIN

		RETURN QUERY
		SELECT CategoryNo, RegUserNo, RegDate, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM Approval_FormCategories
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT CategoryNo, RegUserNo, RegDate, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM Approval_FormCategories
		WHERE Enabled = TRUE
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
