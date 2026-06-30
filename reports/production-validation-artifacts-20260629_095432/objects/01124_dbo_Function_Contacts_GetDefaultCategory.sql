-- ─── FUNCTION: contacts_getdefaultcategory ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getdefaultcategory(integer);
CREATE OR REPLACE FUNCTION public.contacts_getdefaultcategory(
    reguserno integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN
RETURN QUERY
SELECT GroupNo From ContactsGroup WHERE GroupNo = 1--RegUserNo = RegUserNo-- AND IsDefault = '1';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
