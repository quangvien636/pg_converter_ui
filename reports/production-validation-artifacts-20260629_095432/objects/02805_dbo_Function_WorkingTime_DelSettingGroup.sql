-- ─── FUNCTION: workingtime_delsettinggroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_delsettinggroup(integer);
CREATE OR REPLACE FUNCTION public.workingtime_delsettinggroup(
    p_id integer
) RETURNS void
AS $function$
BEGIN

	UPDATE  WorkingTime_SettingGroup
	SET Statust = 0
	WHERE ID = workingtime_delsettinggroup.p_id;;
	UPDATE Organization_Users set GroupId = null
	WHERE GroupId =  workingtime_delsettinggroup.p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
