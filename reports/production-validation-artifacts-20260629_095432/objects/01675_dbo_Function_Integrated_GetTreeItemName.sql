-- ─── FUNCTION: integrated_gettreeitemname ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_gettreeitemname(integer);
CREATE OR REPLACE FUNCTION public.integrated_gettreeitemname(
    id integer
) RETURNS TABLE(
    name text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT Name FROM Integrated_TreeItem
	WHERE ID=integrated_gettreeitemname.id	
END;

-----------------------////////////////////------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
