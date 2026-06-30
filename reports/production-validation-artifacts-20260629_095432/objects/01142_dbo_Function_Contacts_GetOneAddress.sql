-- ─── FUNCTION: contacts_getoneaddress ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getoneaddress(integer);
CREATE OR REPLACE FUNCTION public.contacts_getoneaddress(
    contactid integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select /* /* TOP 1 */ */ Address
	From ContactsAddress
	where UserSeq=contacts_getoneaddress.contactid
	order by Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
