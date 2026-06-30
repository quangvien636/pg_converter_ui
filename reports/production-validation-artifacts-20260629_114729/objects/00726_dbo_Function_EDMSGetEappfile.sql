-- ─── FUNCTION: edmsgeteappfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgeteappfile();
CREATE OR REPLACE FUNCTION public.edmsgeteappfile(
) RETURNS TABLE(
    id integer,
    eddocid integer,
    showname character varying,
    realname character varying
)
AS $function$
#variable_conflict use_column
BEGIN
 
/*
	RETURN QUERY
	select * from EDMSTreeItem where divid = '1' 	
--*/	
	
	INSERT INTO Parenttable
	RETURN QUERY
	select	ID
	,		Docid
	,		ATTACHNAME+ATTACHFLAG
	,		AttaChpath + ATTACHNAME+ATTACHFLAG 
	from edmsfile
	where	docid = Docid

	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
