-- ─── PROCEDURE→FUNCTION: contacts_getusergroupbyuserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getusergroupbyuserno(integer);
CREATE OR REPLACE FUNCTION public.contacts_getusergroupbyuserno(
    IN reguserno integer DEFAULT 70--
) RETURNS SETOF record
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
