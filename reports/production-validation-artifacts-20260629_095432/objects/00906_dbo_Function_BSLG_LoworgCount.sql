-- ─── FUNCTION: bslg_loworgcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_loworgcount(character varying);
CREATE OR REPLACE FUNCTION public.bslg_loworgcount(
    orgcd character varying
) RETURNS TABLE(
    cut text
)
AS $function$
BEGIN
RETURN QUERY
select	count(a.grpnm1) as cut
from	cmongroup a 
		inner join cmonorgan b 
		on b.parentorgcd = bslg_loworgcount.orgcd
where	grpcd = substring(b.orgpath,1,4);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
