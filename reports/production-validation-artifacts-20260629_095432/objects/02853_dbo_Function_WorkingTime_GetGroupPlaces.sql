-- ─── FUNCTION: workingtime_getgroupplaces ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getgroupplaces(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getgroupplaces(
    p_type integer
) RETURNS TABLE(
    col1 text,
    name text,
    name_en text
)
AS $function$
BEGIN


RETURN QUERY
select g.* , u.Name, u.Name_EN
from WorkingTime_GroupPlace g
left join Organization_Users u on g.RegUserNo = u.UserNo
where g.GType = workingtime_getgroupplaces.p_type;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
