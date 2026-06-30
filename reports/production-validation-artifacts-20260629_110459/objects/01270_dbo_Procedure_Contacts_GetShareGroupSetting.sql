-- ─── PROCEDURE→FUNCTION: contacts_getsharegroupsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getsharegroupsetting(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getsharegroupsetting(
    IN langcode character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT SG.ShareGroupNo AS Id,
	ShareGroupName AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME=contacts_getsharegroupsetting.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME='KO')) ELSE SG.ShareGroupName END,'') AS Name ,
	ParentNo 
	FROM  Contact_ShareGroup SG
	WHERE SG.IsDelete= FALSE  
	ORDER BY  SG.ParentNo, SG.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
