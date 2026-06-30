-- ─── FUNCTION: integrated_gettreeitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_gettreeitem(integer);
CREATE OR REPLACE FUNCTION public.integrated_gettreeitem(
    id integer
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
	
	RETURN QUERY
	select * from Integrated_TreeItem WHERE	ID = integrated_gettreeitem.id	
	END;
	
	
--------------------///////////////----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
