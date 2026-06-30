-- ─── FUNCTION: edms_getfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getfolders(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getfolders(
    divid character varying,
    parentid integer,
    langindex integer
) RETURNS TABLE(
    id text,
    itemnm text,
    sortord text,
    parentid text,
    foldertype text
)
AS $function$
BEGIN

RETURN QUERY
SELECT ID,(case when LangIndex = 1  then ItemNm1
			when LangIndex=2 then ItemNm2
			when LangIndex=3 then ItemNm3
			when LangIndex=4 then ItemNm4
		end) AS ItemNm,
		SortOrd, ParentID,'2' AS FolderType 
FROM
	EDMSTreeItem 
WHERE
	DivID = edms_getfolders.divid
	AND UseYn = 'Y'
	AND ParentID=edms_getfolders.parentid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
