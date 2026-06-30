-- ─── FUNCTION: contacts_getsharegroupbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getsharegroupbyuser(integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getsharegroupbyuser(
    userno integer DEFAULT 70,
    isadmin boolean DEFAULT TRUE,
    langcode character varying DEFAULT 'KO'
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF(IsAdmin = TRUE)  
BEGIN
	RETURN QUERY
	SELECT * FROM (SELECT SG.ShareGroupNo AS Id,
	ShareGroupName AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME=contacts_getsharegroupbyuser.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME='KO')) ELSE SG.ShareGroupName END,'') AS Name ,
	ParentNo ,Sort
	FROM  Contact_ShareGroup SG
	WHERE SG.IsDelete= FALSE  
	UNION ALL
	SELECT 0 AS Id,'' as JsonName,'' AS Name,-1 AS ParentNo,0 AS Sort) T
	ORDER BY  T.ParentNo, T.Sort
END
ELSE
BEGIN
	WITH  DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo 
		FROM Contact_DepartAllowAccess BD 
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE  OB.UserNo=contacts_getsharegroupbyuser.userno AND OB.IsDefault= TRUE
	)
	RETURN QUERY
	SELECT SG.ShareGroupNo AS Id,
	COALESCE(ShareGroupName,'') AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME=contacts_getsharegroupbyuser.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME='KO')) ELSE SG.ShareGroupName END,'') AS Name ,
	COALESCE(ParentNo,-1) AS ParentNo
	FROM DEPARTPERMISSION D
	LEFT JOIN Contact_ShareGroup SG   ON D.ItemNo=SG.ShareGroupNo AND SG.IsDelete= FALSE 
	--FROM  Contact_ShareGroup SG
	--INNER JOIN DEPARTPERMISSION D ON D.ItemNo=SG.ShareGroupNo AND SG.IsDelete= FALSE  
	 WHERE   D.AllowValue>4  
	ORDER BY  SG.ParentNo, SG.Sort
END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
