-- ─── PROCEDURE→FUNCTION: contacts_checkexitgroupandcontact ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_checkexitgroupandcontact(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_checkexitgroupandcontact(
    IN userno integer,
    IN contactid integer,
    IN groupid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COUNT(*) FROM ContactsGroupUser
	WHERE RegUserNo=contacts_checkexitgroupandcontact.userno AND UserSeq=contacts_checkexitgroupandcontact.contactid AND GroupNo=contacts_checkexitgroupandcontact.groupid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
