-- ─── FUNCTION: contact_getgroupdefaultbyuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.contact_getgroupdefaultbyuserno(integer);
CREATE OR REPLACE FUNCTION public.contact_getgroupdefaultbyuserno(
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    groupno integer;
BEGIN



 select GroupNo = GroupNo from ContactsGroup	where RegUserNo=contact_getgroupdefaultbyuserno.userno and IsDefault=IsDefault and UseYn='Y'	
 RETURN QUERY
 select GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
