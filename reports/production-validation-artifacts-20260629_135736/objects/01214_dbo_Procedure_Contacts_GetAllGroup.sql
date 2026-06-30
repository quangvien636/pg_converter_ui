-- ─── PROCEDURE→FUNCTION: contacts_getallgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getallgroup(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getallgroup(
    IN reguserno integer DEFAULT 70,
    IN langcode character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH  ContactsGroups AS 
		(
		   SELECT CGP.GroupNo,CGP.GroupNo AS RootGroupNo, CGP.GroupName, CGP.RegUserNo, CGP.RegDate, CGP.Memo, CGP.ParentGNo, CGP.Sort, CGP.IsDefault,CGP.UseYn
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y' AND CGP.ParentGNo=0 AND  CGP.RegUserNo=contacts_getallgroup.reguserno
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGroupNo, CGC.GroupName, CGC.RegUserNo, CGC.RegDate, CGC.Memo, CGC.ParentGNo, CGC.Sort, CGC.IsDefault,CGC.UseYn
		  FROM ContactsGroup CGC 
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y' AND   CGC.RegUserNo=contacts_getallgroup.reguserno
	)
	RETURN QUERY
	SELECT CG.GroupNo,CG.GroupName,CG.RootGroupNo,CG.RegUserNo,CG.RegDate,CG.Memo,CG.ParentGNo,CG.Sort,CG.IsDefault,
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq  
		WHERE U.UseYn='Y' AND C.GroupNo =CG.GroupNo
	) AS UserCount,
	CASE WHEN STRPOS(CG.GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson( CG.GroupName)  WHERE NAME=contacts_getallgroup.langcode) ELSE CG.GroupName END AS  Name 
	FROM ContactsGroups  CG
	WHERE CG.RegUserNo=contacts_getallgroup.reguserno AND CG.UseYn='Y' ORDER BY CG.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
