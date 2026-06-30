-- ─── PROCEDURE→FUNCTION: edmsselecttreename ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.edmsselecttreename(integer);
CREATE OR REPLACE FUNCTION public.edmsselecttreename(
    IN documentid integer
) RETURNS SETOF record
AS $function$
DECLARE
    edmsdocid integer;
    edmsstore character varying;
    div1 integer;
    div2 integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	
RETURN QUERY
SELECT '' as DirNo, '' as lvl,'' as DivID, '' as path,'' as edmsstore
return	
	
	SELECT EDMSID INTO edmsdocid from EAPPDocument where ID=edmsselecttreename.documentid
	EDMSStore := (case convert(varchar,storeperiod) when '0' then '영구' else convert(varchar,storeperiod) + '개월' end from EDMSDocument where ID=EDMSDocID);
	RETURN QUERY
	select /* TOP 1 */ DIV1=id from EDMSTreeItem where ID in (select FolderID from EDMSDocFolder where DocID=EDMSDocID) and DivID='1';

	RETURN QUERY
	select /* TOP 1 */ DIV2=id from EDMSTreeItem where ID in (select FolderID from EDMSDocFolder where DocID=EDMSDocID) and DivID='2';


WITH cte (ParentDirNo, DirNo,DivID, lvl, path) 
AS
(
SELECT ParentID, ID,DivID, 1 AS lvl, CONVERT(VARCHAR(250), '/' || ItemNm1) AS path
FROM EDMSTreeItem
WHERE ParentID = '0'
UNION ALL
SELECT a.ParentID, a.ID, a.DivID,lvl + 1, CONVERT(VARCHAR(250), path || '/' || a.ItemNm1) 
FROM EDMSTreeItem a, cte b 
WHERE a.ParentID = cast(b.DirNo AS text)
)
RETURN QUERY
SELECT DirNo, lvl,DivID, path,EDMSStore as edmsstore FROM cte where (DirNo=DIV1 or DirNo=DIV2) ORDER BY lvl;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
