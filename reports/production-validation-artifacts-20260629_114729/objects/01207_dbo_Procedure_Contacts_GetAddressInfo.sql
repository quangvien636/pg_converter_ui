-- ─── PROCEDURE→FUNCTION: contacts_getaddressinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getaddressinfo();
CREATE OR REPLACE FUNCTION public.contacts_getaddressinfo(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE Seq = Seq
	RETURN QUERY
	SELECT * FROM ContactsNumber WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsSns WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM Contact_PublicGroupUser WHERE UserSeq = Seq AND IsDelete= FALSE
	RETURN QUERY
	SELECT * FROM Contact_ShareGroupUser WHERE UserSeq = Seq AND IsDelete= FALSE;
	UPDATE ContactsUser 
	ViewCount := ViewCount+1;
	WHERE Seq = Seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
