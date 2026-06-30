-- ─── FUNCTION: bslg_loworg ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_loworg(character varying);
CREATE OR REPLACE FUNCTION public.bslg_loworg(
    orgcd character varying
) RETURNS TABLE(
    orgnm1 text,
    orgcd text
)
AS $function$
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
