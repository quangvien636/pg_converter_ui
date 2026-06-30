-- ─── FUNCTION: contacts_parentgroupno ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_parentgroupno(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_parentgroupno(
    reguserno integer,
    groupno integer
) RETURNS TABLE(
    parentgno text
)
AS $function$
BEGIN
	RETURN QUERY
	SELECT ParentGNo FROM ContactsGroup WHERE RegUserNo = contacts_parentgroupno.reguserno and GroupNo = contacts_parentgroupno.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
