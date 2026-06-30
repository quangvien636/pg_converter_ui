-- ─── FUNCTION: workingtime_savesetupitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_savesetupitem(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_savesetupitem(
    p_checkout character varying,
    p_workoutside character varying,
    p_returnv character varying,
    p_wfh character varying,
    p_early character varying,
    p_nightwork character varying,
    p_extension character varying,
    p_training character varying,
    p_holiday character varying,
    p_quatertoff character varying DEFAULT 'N',
    p_haftoff character varying DEFAULT 'N',
    p_alloff character varying DEFAULT 'N'
) RETURNS void
AS $function$
BEGIN

	
	update WorkingTime_setupitems 
	set checkin = p_checkin
		,checkout = workingtime_savesetupitem.p_checkout
		,workoutside = workingtime_savesetupitem.p_workoutside
		,returnv = workingtime_savesetupitem.p_returnv
		,wfh = workingtime_savesetupitem.p_wfh
		,early = workingtime_savesetupitem.p_early
		,nightwork = workingtime_savesetupitem.p_nightwork
		,extension = workingtime_savesetupitem.p_extension
		,training = workingtime_savesetupitem.p_training
		,holiday = workingtime_savesetupitem.p_holiday
		,quatertoff = workingtime_savesetupitem.p_quatertoff
		,haftoff = workingtime_savesetupitem.p_haftoff
		,alloff = workingtime_savesetupitem.p_alloff;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
