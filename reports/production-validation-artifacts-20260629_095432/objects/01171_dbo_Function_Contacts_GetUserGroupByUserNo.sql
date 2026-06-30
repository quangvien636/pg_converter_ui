-- ─── FUNCTION: contacts_getusergroupbyuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getusergroupbyuserno(integer);
CREATE OR REPLACE FUNCTION public.contacts_getusergroupbyuserno(
    reguserno integer DEFAULT 70--
) RETURNS TABLE(
    groupno text
)
AS $function$
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
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, COALESCE(ParentGNo,0) AS ParentGNo, Sort, IsDefault, 
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq  
		WHERE U.UseYn='Y' AND C.GroupNo IN (SELECT GroupNo FROM ContactsGroups WHERE RootGourpNo=CG.GroupNo)
	) AS UserCount,
	UseYn
	FROM ContactsGroup CG
	WHERE CG.RegUserNo=contacts_getusergroupbyuserno.reguserno AND CG.UseYn='Y' 
	ORDER BY CG.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
