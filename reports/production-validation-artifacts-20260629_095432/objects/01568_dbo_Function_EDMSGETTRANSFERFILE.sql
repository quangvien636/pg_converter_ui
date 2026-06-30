-- ─── FUNCTION: edmsgettransferfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgettransferfile(integer);
CREATE OR REPLACE FUNCTION public.edmsgettransferfile(
    docid integer
) RETURNS TABLE(
    id text,
    docid text,
    attachpath text,
    attachname text,
    attachflag text,
    ispdf text
)
AS $function$
DECLARE
    docid integer;
BEGIN
/*

--*/	

 	RETURN QUERY
 	SELECT ID
	,	DOCID
	,	ATTACHPATH
	,	ATTACHNAME
	,	ATTACHFLAG
	,	ISPDF
	FROM EDMSFILE 	
	WHERE DOCID = edmsgettransferfile.docid
	AND		ISPDF = '';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
