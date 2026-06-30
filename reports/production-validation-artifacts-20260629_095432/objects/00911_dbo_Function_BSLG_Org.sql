-- ─── FUNCTION: bslg_org ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_org(character varying);
CREATE OR REPLACE FUNCTION public.bslg_org(
    userid character varying
) RETURNS TABLE(
    grpcd text,
    grpnm1 text,
    orgcd text,
    orgnm1 text,
    parentorgcd text,
    orgpath text,
    userid text,
    usernm1 text,
    orgcd1 text
)
AS $function$
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
