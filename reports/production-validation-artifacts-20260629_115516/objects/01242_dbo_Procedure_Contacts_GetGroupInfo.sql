-- ─── PROCEDURE→FUNCTION: contacts_getgroupinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getgroupinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_getgroupinfo(
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault 
	,(SELECT COUNT(*) FROM ContactsGroupUser C WHERE C.GroupNo = ContactsGroup.GroupNo) AS UserCount
	FROM ContactsGroup
	WHERE GroupNo = contacts_getgroupinfo.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
