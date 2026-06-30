-- ─── PROCEDURE→FUNCTION: contacts_deletesharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_deletesharegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deletesharegroup(
    IN userno integer,
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE  Contact_ShareGroup SET IsDelete = TRUE,  ModUserNo=contacts_deletesharegroup.userno,ModDate=NOW()
	WHERE ShareGroupNo=contacts_deletesharegroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
