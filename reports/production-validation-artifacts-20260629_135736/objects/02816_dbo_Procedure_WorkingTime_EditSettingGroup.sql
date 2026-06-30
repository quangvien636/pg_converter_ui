-- ─── PROCEDURE→FUNCTION: workingtime_editsettinggroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_editsettinggroup(integer, character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_editsettinggroup(
    IN p_id integer,
    IN p_name character varying,
    IN p_timein character varying,
    IN p_timeout character varying,
    IN p_lunchstar character varying,
    IN p_lunchend character varying,
    IN p_check boolean,
    IN p_bin1 character varying,
    IN p_bout1 character varying,
    IN p_bin2 character varying,
    IN p_bout2 character varying,
    IN p_isb1 character varying,
    IN p_isb2 character varying,
    IN p_userid integer,
    IN p_sun integer,
    IN p_mon integer,
    IN p_tue integer,
    IN p_wen integer,
    IN p_thu integer,
    IN p_fri integer,
    IN p_sat integer
) RETURNS void
AS $function$
BEGIN

	UPDATE  WorkingTime_SettingGroup
	Name := workingtime_editsettinggroup.p_name;
		, TimeIn = workingtime_editsettinggroup.p_timein
		, TimeOut = workingtime_editsettinggroup.p_timeout
		, LunchStart = workingtime_editsettinggroup.p_lunchstar
		, LunchEnd = workingtime_editsettinggroup.p_lunchend
		, IsAddLunch =  workingtime_editsettinggroup.p_check
		, BIn1 = workingtime_editsettinggroup.p_bin1
		, BOut1= workingtime_editsettinggroup.p_bout1
		, BIn2 = workingtime_editsettinggroup.p_bin2
		, BOut2= workingtime_editsettinggroup.p_bout2
		, IsB1 = workingtime_editsettinggroup.p_isb1
		, IsB2 = workingtime_editsettinggroup.p_isb2
		, UpdateId = workingtime_editsettinggroup.p_userid
		, UpdatedDate = NOW()
		, Sun = workingtime_editsettinggroup.p_sun
		, Mon = workingtime_editsettinggroup.p_mon
		, Tue = workingtime_editsettinggroup.p_tue
		, Wen = workingtime_editsettinggroup.p_wen
		, Thur = workingtime_editsettinggroup.p_thu
		, Fri = workingtime_editsettinggroup.p_fri
		, Sat = workingtime_editsettinggroup.p_sat
	WHERE ID = workingtime_editsettinggroup.p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
