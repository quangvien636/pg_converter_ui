-- ─── FUNCTION: integrated_unissettreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_unissettreeitem(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_unissettreeitem(
    id integer,
    parentid integer,
    regid character varying
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	update  Integrated_TreeItem
	set 
	IsSet='',
	RegID=integrated_unissettreeitem.regid,
	ModDate=NOW()
	where ID=integrated_unissettreeitem.id



	RETURN QUERY
	SELECT /* TOP 1 */ *	
	FROM 	Integrated_TreeItem
	WHERE	ParentID=integrated_unissettreeitem.parentid and UseYn='Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
