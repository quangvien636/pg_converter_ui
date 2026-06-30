-- ─── FUNCTION: integrated_gettreeitembyid ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_gettreeitembyid(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_gettreeitembyid(
    parentid integer,
    treeid integer,
    useyn character varying
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
	SELECT *	
		FROM Integrated_TreeItem
		WHERE	PARENTID = integrated_gettreeitembyid.parentid	
		--and TreeID	=	TreeID
		and UseYn = integrated_gettreeitembyid.useyn;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
