-- ─── FUNCTION: splitstring ───────────────────────────────
DROP FUNCTION IF EXISTS public.splitstring(character varying);
CREATE OR REPLACE FUNCTION public.splitstring(
    string character varying
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
DECLARE
    ispaces integer;
    part character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	--initialize spaces
	Select iSpaces = STRPOS(String,0, Deliminator)
	While iSpaces > 0
	
	BEGIN
		Select part = substring(String,0,STRPOS(String,0, Deliminator));
			Insert Into ReturnTable(SplitItem)
			RETURN QUERY
			Select part
			Select String = substring(String,STRPOS(String,0, Deliminator)+ len(Deliminator),len(String) - STRPOS(String,0, ' '))
			Select iSpaces = STRPOS(String,0, Deliminator)
	END
	
    If len(String) > 0;
    Insert Into ReturnTable
    RETURN QUERY
    Select String
    
    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
