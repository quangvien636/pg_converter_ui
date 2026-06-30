-- ─── FUNCTION: contacts_getsharegroupsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getsharegroupsetting(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getsharegroupsetting(
    langcode character varying DEFAULT 'KO'
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
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
