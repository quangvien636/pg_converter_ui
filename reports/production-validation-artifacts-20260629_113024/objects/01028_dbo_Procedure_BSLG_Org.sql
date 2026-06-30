-- ─── PROCEDURE→FUNCTION: bslg_org ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_org(character varying);
CREATE OR REPLACE FUNCTION public.bslg_org(
    IN userid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
select	a.grpcd, a.grpnm1, b.orgcd, b.orgnm1, b.parentorgcd, b.orgpath, c.userid, c.usernm1, c.orgcd1
from	cmongroup a 
		inner join cmonorgan b 
		on a.grpcd = substring(b.orgpath, 1, 4)
		inner join cmonusers c
		on b.orgcd = c.orgcd1
where	userid = bslg_org.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
