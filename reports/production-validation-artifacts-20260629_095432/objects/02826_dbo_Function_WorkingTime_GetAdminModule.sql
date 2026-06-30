-- ─── FUNCTION: workingtime_getadminmodule ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getadminmodule();
CREATE OR REPLACE FUNCTION public.workingtime_getadminmodule(
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN


	
RETURN QUERY
select m.UserNo 
from Authority_ModulePermission m 
join Center_Applications c on m.ApplicationNo = c.ApplicationNo
where c.projectCode = 'WorkingTime'
union 
RETURN QUERY
select UserNo from Authority_SitePermissions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
