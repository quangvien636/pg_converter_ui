-- ─── PROCEDURE→FUNCTION: contacts_deletepublicgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_deletepublicgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deletepublicgroup(
    IN userno integer DEFAULT 70,
    IN groupno integer DEFAULT 12
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE  Contact_PublicGroup SET IsDelete = TRUE,  ModUserNo=contacts_deletepublicgroup.userno,ModDate=NOW()
	WHERE PublicGroupNo=contacts_deletepublicgroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
