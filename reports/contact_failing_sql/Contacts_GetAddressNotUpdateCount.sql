-- ─── PROCEDURE→FUNCTION: contacts_getaddressnotupdatecount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getaddressnotupdatecount(integer);
CREATE OR REPLACE FUNCTION public.contacts_getaddressnotupdatecount(
    IN seq integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE Seq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsNumber WHERE UserSeq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE UserSeq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE UserSeq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE UserSeq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE UserSeq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsSns WHERE UserSeq = contacts_getaddressnotupdatecount.seq
	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE UserSeq = contacts_getaddressnotupdatecount.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.