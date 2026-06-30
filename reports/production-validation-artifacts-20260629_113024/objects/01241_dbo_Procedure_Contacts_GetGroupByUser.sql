-- ─── PROCEDURE→FUNCTION: contacts_getgroupbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getgroupbyuser(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getgroupbyuser(
    IN reguserno integer DEFAULT '',
    IN userseq integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 IF (SELECT COUNT(*) FROM ContactsGroup  WHERE RegUserNo=contacts_getgroupbyuser.reguserno AND UseYn='Y')<=0 THEN
	EXEC Contacts_InsertGroup RegUserNo,'임시 그룹',0
 END IF;


	RETURN QUERY
	SELECT distinct c.GroupNo, c.GroupName, c.RegUserNo, c.RegDate, c.Memo, c.ParentGNo, c.Sort, c.IsDefault, 
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser Cc
		INNER JOIN ContactsUser U ON U.Seq = Cc.UserSeq AND U.UseYn='Y'
		WHERE Cc.GroupNo = c.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup c
	left join ContactsGroupUser g on c.groupno=g.groupno
	WHERE c.RegUserNo=contacts_getgroupbyuser.reguserno AND c.UseYn='Y' --and --g.userseq=UserSeq
	 ORDER BY c.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
