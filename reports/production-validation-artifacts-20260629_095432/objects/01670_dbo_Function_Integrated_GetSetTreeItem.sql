-- ─── FUNCTION: integrated_getsettreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getsettreeitem(integer);
CREATE OR REPLACE FUNCTION public.integrated_getsettreeitem(
    parentid integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ *	
	FROM 	Integrated_TreeItem
	WHERE	ParentID=integrated_getsettreeitem.parentid and IsSet='Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
