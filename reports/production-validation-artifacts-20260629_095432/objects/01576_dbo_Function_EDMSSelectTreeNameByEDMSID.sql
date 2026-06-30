-- ─── FUNCTION: edmsselecttreenamebyedmsid ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsselecttreenamebyedmsid(integer);
CREATE OR REPLACE FUNCTION public.edmsselecttreenamebyedmsid(
    edmsid integer
) RETURNS TABLE(
    dirno text,
    lvl text,
    path text,
    edmsstore text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




RETURN QUERY
SELECT '' as DirNo, '' as lvl, '' as path,'' as edmsstore
return 	
	
RETURN QUERY
select /* TOP 1 */ DIV1=id from EDMSTreeItem where ID =edmsselecttreenamebyedmsid.edmsid;

	


WITH cte (ParentDirNo, DirNo, lvl, path) 
AS
(
SELECT ParentID, ID, 1 AS lvl, CONVERT(VARCHAR(250), '/' || ItemNm1) AS path
FROM EDMSTreeItem
WHERE ParentID = 0
UNION ALL
SELECT a.ParentID, a.ID, lvl + 1, CONVERT(VARCHAR(250), path || '/' || a.ItemNm1) 
FROM EDMSTreeItem a, cte b 
WHERE a.ParentID = b.DirNo
)
RETURN QUERY
SELECT DirNo, lvl, path,EDMSStore as edmsstore FROM cte where DirNo=DIV1 ORDER BY lvl;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
