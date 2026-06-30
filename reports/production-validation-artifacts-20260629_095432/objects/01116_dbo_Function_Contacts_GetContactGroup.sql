-- ─── FUNCTION: contacts_getcontactgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcontactgroup(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getcontactgroup(
    userno integer DEFAULT 70,
    langcode character varying DEFAULT 'KO'
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH  ContactsGroups AS 
		(
		   SELECT CGP.GroupNo,CGP.GroupNo AS RootGroupNo, CGP.GroupName, CGP.RegUserNo, CGP.RegDate, CGP.Memo, CGP.ParentGNo, CGP.Sort, CGP.IsDefault,CGP.UseYn
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y' AND CGP.ParentGNo=0 AND  CGP.RegUserNo=contacts_getcontactgroup.userno
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGroupNo, CGC.GroupName, CGC.RegUserNo, CGC.RegDate, CGC.Memo, CGC.ParentGNo, CGC.Sort, CGC.IsDefault,CGC.UseYn
		  FROM ContactsGroup CGC 
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y' AND   CGC.RegUserNo=contacts_getcontactgroup.userno
	)
	RETURN QUERY
	SELECT CG.GroupNo AS Id,CG.GroupName AS JsonName,CG.ParentGNo AS ParentNo  ,
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq  
		WHERE U.UseYn='Y' AND C.GroupNo =CG.GroupNo
	) AS ShareNumber,
	CASE WHEN STRPOS(CG.GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson( CG.GroupName)  WHERE NAME=contacts_getcontactgroup.langcode) ELSE CG.GroupName END AS Name 
	FROM ContactsGroups  CG
	WHERE CG.RegUserNo=contacts_getcontactgroup.userno AND CG.UseYn='Y' ORDER BY CG.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
