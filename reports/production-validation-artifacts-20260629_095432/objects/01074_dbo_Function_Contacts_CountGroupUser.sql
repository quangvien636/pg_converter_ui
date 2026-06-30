-- ─── FUNCTION: contacts_countgroupuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_countgroupuser(integer);
CREATE OR REPLACE FUNCTION public.contacts_countgroupuser(
    reguserno integer
) RETURNS TABLE(
    countgroup text
)
AS $function$
BEGIN

	RETURN QUERY
	select count(*) as countgroup from ContactsGroup 
    where RegUserNo=contacts_countgroupuser.reguserno and UseYn='Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
