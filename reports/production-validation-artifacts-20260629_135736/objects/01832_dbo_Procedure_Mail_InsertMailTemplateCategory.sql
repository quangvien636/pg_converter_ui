-- ─── PROCEDURE→FUNCTION: mail_insertmailtemplatecategory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.mail_insertmailtemplatecategory();
CREATE OR REPLACE FUNCTION public.mail_insertmailtemplatecategory(
) RETURNS SETOF record
AS $function$
DECLARE
    categoryno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailTemplateCategories (Name, SortNo, Enabled)
	VALUES (Name, COALESCE((SELECT /* TOP 1 */ SortNo + 1 FROM Mail_MailTemplateCategories ORDER BY SortNo DESC), 0), 1)
	

	CategoryNo := lastval();
	RETURN QUERY
	SELECT CategoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
