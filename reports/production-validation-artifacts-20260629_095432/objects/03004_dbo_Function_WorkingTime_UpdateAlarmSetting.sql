-- ─── FUNCTION: workingtime_updatealarmsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updatealarmsetting(integer, integer, integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_updatealarmsetting(
    p_id integer,
    p_alam integer,
    p_type integer,
    p_t character varying,
    p_ten character varying,
    p_tjp character varying,
    p_tvi character varying
) RETURNS void
AS $function$
BEGIN


	update WorkingTime_AlarmSetting 
	set  IsAlarm = workingtime_updatealarmsetting.p_alam,
		 Type =workingtime_updatealarmsetting.p_type,
		 alText = workingtime_updatealarmsetting.p_t,
		 alTextEn = workingtime_updatealarmsetting.p_ten,
		 alTextJP = workingtime_updatealarmsetting.p_tjp,
		 alTextVi = workingtime_updatealarmsetting.p_tvi,
		 alTextCi = p_tci

	Where Id = workingtime_updatealarmsetting.p_id ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
