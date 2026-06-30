-- ─── PROCEDURE→FUNCTION: contact_getgroupdefaultbyuserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contact_getgroupdefaultbyuserno(integer);
CREATE OR REPLACE FUNCTION public.contact_getgroupdefaultbyuserno(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



 SELECT GroupNo INTO groupno from ContactsGroup	where RegUserNo=contact_getgroupdefaultbyuserno.userno and IsDefault=IsDefault and UseYn='Y'
 RETURN QUERY
 select GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.