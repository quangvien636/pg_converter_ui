-- ─── PROCEDURE→FUNCTION: contacts_getaddressinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getaddressinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_getaddressinfo(
    IN seq integer DEFAULT 7997
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE Seq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsNumber WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsSns WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE UserSeq = contacts_getaddressinfo.seq
	RETURN QUERY
	SELECT * FROM Contact_PublicGroupUser WHERE UserSeq = contacts_getaddressinfo.seq AND IsDelete= FALSE
	RETURN QUERY
	SELECT * FROM Contact_ShareGroupUser WHERE UserSeq = contacts_getaddressinfo.seq AND IsDelete= FALSE;
	UPDATE ContactsUser
	SET
		ViewCount = ViewCount+1
	WHERE Seq = contacts_getaddressinfo.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.