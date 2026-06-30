-- ─── FUNCTION: integrated_deletetreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_deletetreeitem(integer);
CREATE OR REPLACE FUNCTION public.integrated_deletetreeitem(
    id integer
) RETURNS void
AS $function$
BEGIN
	
	Delete from Integrated_TreeItem WHERE	ID = integrated_deletetreeitem.id	
	END;


----------------------------///////////-----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
