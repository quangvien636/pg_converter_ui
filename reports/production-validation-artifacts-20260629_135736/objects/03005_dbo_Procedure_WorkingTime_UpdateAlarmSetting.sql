-- ─── PROCEDURE→FUNCTION: workingtime_updatealarmsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updatealarmsetting(integer, integer, integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_updatealarmsetting(
    IN p_id integer,
    IN p_alam integer,
    IN p_type integer,
    IN p_t character varying,
    IN p_ten character varying,
    IN p_tjp character varying,
    IN p_tvi character varying
) RETURNS void
AS $function$
BEGIN


	update WorkingTime_AlarmSetting 
	IsAlarm := workingtime_updatealarmsetting.p_alam,;
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
