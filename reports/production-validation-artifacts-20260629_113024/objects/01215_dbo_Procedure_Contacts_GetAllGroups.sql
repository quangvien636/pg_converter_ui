-- ─── PROCEDURE→FUNCTION: contacts_getallgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getallgroups(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallgroups(
    IN reguserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault, 
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq AND U.UseYn='Y'
		WHERE C.GroupNo = ContactsGroup.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup 
	WHERE RegUserNo=contacts_getallgroups.reguserno AND UseYn='Y'
	ORDER BY Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
