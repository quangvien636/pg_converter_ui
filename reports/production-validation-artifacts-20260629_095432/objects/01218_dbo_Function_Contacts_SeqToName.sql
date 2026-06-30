-- ─── FUNCTION: contacts_seqtoname ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_seqtoname(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_seqtoname(
    seq integer,
    reguserno integer
) RETURNS TABLE(
    groupname text
)
AS $function$
BEGIN
RETURN QUERY
SELECT GroupName FROM ContactsGroup WHERE GroupNo = contacts_seqtoname.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
