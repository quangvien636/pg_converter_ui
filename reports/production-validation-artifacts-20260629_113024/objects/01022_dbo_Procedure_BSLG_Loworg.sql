-- ─── PROCEDURE→FUNCTION: bslg_loworg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_loworg(character varying);
CREATE OR REPLACE FUNCTION public.bslg_loworg(
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
select	b.orgnm1, b.orgcd
from	cmongroup a 
		inner join cmonorgan b 
		on b.parentorgcd = bslg_loworg.orgcd
where	grpcd = substring(b.orgpath,1,4);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
