-- ─── FUNCTION: contacts_countgroupcountchild ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_countgroupcountchild(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_countgroupcountchild(
    reguserno integer,
    groupno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
 RETURN QUERY
 select count(*) from ContactsGroup 
    where ContactsGroup.RegUserNo=contacts_countgroupcountchild.reguserno and ContactsGroup.ParentGNo=contacts_countgroupcountchild.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
