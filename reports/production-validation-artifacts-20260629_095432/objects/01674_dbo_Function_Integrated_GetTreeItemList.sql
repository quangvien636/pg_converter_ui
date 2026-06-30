-- ─── FUNCTION: integrated_gettreeitemlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_gettreeitemlist(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_gettreeitemlist(
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
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    tempid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET TempId = 0
	IF(UseYn='Y') BEGIN
		RETURN QUERY
		select /* TOP 1 */ TempId= ID from Integrated_TreeItem where UseYn=integrated_gettreeitemlist.useyn and ParentID=integrated_gettreeitemlist.parentid
		RETURN QUERY
		SELECT *	
		FROM 	Integrated_TreeItem
		WHERE	PARENTID = TempId	
		and TreeID	=	integrated_gettreeitemlist.treeid
		ORDER BY SortOrd asc, RegDate desc	
		END
	ELSE
	BEGIN	
	RETURN QUERY
	SELECT *	
		FROM Integrated_TreeItem
		WHERE	PARENTID = integrated_gettreeitemlist.parentid	
		and TreeID	=	integrated_gettreeitemlist.treeid
		ORDER BY SortOrd asc, RegDate desc
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
