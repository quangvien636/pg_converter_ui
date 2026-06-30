-- ─── FUNCTION: workingtime_getsettinggroupbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsettinggroupbyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsettinggroupbyuser(
    p_uid integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	select g.*
	from Organization_Users u 
	LEFT JOIN WorkingTime_SettingGroup g
	ON U.GroupId = g.Id
	where u.UserNo = workingtime_getsettinggroupbyuser.p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
