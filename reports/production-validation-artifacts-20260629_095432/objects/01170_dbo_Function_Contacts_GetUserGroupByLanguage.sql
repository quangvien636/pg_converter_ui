-- ─── FUNCTION: contacts_getusergroupbylanguage ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getusergroupbylanguage(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getusergroupbylanguage(
    reguserno integer DEFAULT 70,
    langcode character varying DEFAULT 'EN'
) RETURNS TABLE(
    groupno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH  ContactsGroups AS 
		(
		  SELECT CGP.GroupNo,CGP.GroupNo AS RootGourpNo
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y'
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGourpNo
		  FROM ContactsGroup CGC 
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y'
	)
	RETURN QUERY
	SELECT GroupNo, CASE WHEN STRPOS(GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(GroupName)  WHERE NAME=contacts_getusergroupbylanguage.langcode) ELSE GroupName END AS  GroupName, RegUserNo, RegDate, Memo, COALESCE(ParentGNo,0) AS ParentGNo, Sort, IsDefault, 
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq  
		WHERE U.UseYn='Y' AND C.GroupNo IN (SELECT GroupNo FROM ContactsGroups WHERE RootGourpNo=CG.GroupNo)
	) AS UserCount,
	UseYn
	FROM ContactsGroup CG
	WHERE CG.RegUserNo=contacts_getusergroupbylanguage.reguserno AND CG.UseYn='Y' 
	ORDER BY CG.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
