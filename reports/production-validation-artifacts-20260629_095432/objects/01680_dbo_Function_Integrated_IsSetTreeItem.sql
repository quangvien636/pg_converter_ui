-- ─── FUNCTION: integrated_issettreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_issettreeitem(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_issettreeitem(
    id integer,
    parentid integer,
    regid character varying
) RETURNS TABLE(
    userid character varying(50),
    name character varying(100),
    parentid integer,
    sortord integer,
    useyn character(1),
    regid character varying(50),
    regdate timestamp without time zone,
    modid character varying(50),
    moddate timestamp without time zone,
    id serial,
    treeid integer,
    isset character(1)
)
AS $function$
BEGIN


	update Integrated_TreeItem 
	set 
	IsSet='',
	RegID=integrated_issettreeitem.regid
	where ParentID=integrated_issettreeitem.parentid 


	update  Integrated_TreeItem
	set 
	IsSet='Y',
	RegID=integrated_issettreeitem.regid,
	ModDate=NOW()
	where ID=integrated_issettreeitem.id



	RETURN QUERY
	SELECT *	
	FROM 	Integrated_TreeItem
	WHERE	ID = integrated_issettreeitem.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
