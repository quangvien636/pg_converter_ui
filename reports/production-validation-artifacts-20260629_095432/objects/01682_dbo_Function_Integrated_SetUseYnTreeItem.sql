-- ─── FUNCTION: integrated_setuseyntreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_setuseyntreeitem(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_setuseyntreeitem(
    id integer,
    parentid integer,
    regid character varying
) RETURNS void
AS $function$
BEGIN


	update Integrated_TreeItem 
	set 
	UseYn='',
	RegID=integrated_setuseyntreeitem.regid
	where ParentID=integrated_setuseyntreeitem.parentid 


	update  Integrated_TreeItem
	set 
	UseYn='Y',
	RegID=integrated_setuseyntreeitem.regid,
	ModDate=NOW()
	where ID=integrated_setuseyntreeitem.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
