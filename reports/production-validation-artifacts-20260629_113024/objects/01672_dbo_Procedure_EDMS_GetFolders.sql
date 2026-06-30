-- ─── PROCEDURE→FUNCTION: edms_getfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_getfolders(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getfolders(
    IN divid character varying,
    IN parentid integer,
    IN langindex integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
