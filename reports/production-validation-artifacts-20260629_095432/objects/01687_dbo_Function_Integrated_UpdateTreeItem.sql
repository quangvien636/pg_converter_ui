-- ─── FUNCTION: integrated_updatetreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_updatetreeitem(integer, integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_updatetreeitem(
    id integer,
    parentid integer,
    name character varying,
    treeid integer,
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


	update  Integrated_TreeItem
	set 
	Name=integrated_updatetreeitem.name,
	RegID=integrated_updatetreeitem.regid,
	ModDate=NOW()
	where ID=integrated_updatetreeitem.id



	RETURN QUERY
	SELECT *	
	FROM 	Integrated_TreeItem
	WHERE	PARENTID = integrated_updatetreeitem.parentid
	AND		TreeID = integrated_updatetreeitem.treeid
	ORDER BY SortOrd asc, RegDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
