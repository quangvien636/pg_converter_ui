-- ─── PROCEDURE→FUNCTION: workingtime_savesetupitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_savesetupitem(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_savesetupitem(
    IN p_checkout character varying,
    IN p_workoutside character varying,
    IN p_returnv character varying,
    IN p_wfh character varying,
    IN p_early character varying,
    IN p_nightwork character varying,
    IN p_extension character varying,
    IN p_training character varying,
    IN p_holiday character varying,
    IN p_quatertoff character varying DEFAULT 'N',
    IN p_haftoff character varying DEFAULT 'N',
    IN p_alloff character varying DEFAULT 'N'
) RETURNS void
AS $function$
BEGIN

	
	update WorkingTime_setupitems 
	checkin := p_checkin;
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
