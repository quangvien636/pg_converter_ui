-- ─── FUNCTION: contacts_getcheckgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcheckgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcheckgroup(
    seq integer,
    reguserno integer
) RETURNS TABLE(
    isdefault text
)
AS $function$
BEGIN
RETURN QUERY
SELECT IsDefault FROM ContactsGroup WHERE RegUserNo = contacts_getcheckgroup.reguserno AND GroupNo = contacts_getcheckgroup.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
