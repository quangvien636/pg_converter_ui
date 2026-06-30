-- ─── PROCEDURE→FUNCTION: contacts_updatesharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_updatesharegroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatesharegroup(
    IN userno integer,
    IN groupname character varying,
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE  Contact_ShareGroup SET ShareGroupName =contacts_updatesharegroup.groupname,  ModUserNo=contacts_updatesharegroup.userno,ModDate=NOW()
	WHERE ShareGroupNo=contacts_updatesharegroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
