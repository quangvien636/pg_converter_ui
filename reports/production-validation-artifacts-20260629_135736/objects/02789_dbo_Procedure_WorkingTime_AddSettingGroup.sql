-- ─── PROCEDURE→FUNCTION: workingtime_addsettinggroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_addsettinggroup(character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_addsettinggroup(
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

	INSERT INTO WorkingTime_SettingGroup(Name, TimeIn, TimeOut, LunchStart, LunchEnd, IsAddLunch,BIn1, BOut1,BIn2, BOut2, IsB1, IsB2, RegisteredId, RegisteredDate, UpdateId, UpdatedDate, Statust, Sun, Mon, Tue, Wen, Thur, Fri, Sat)
	values(p_Name,p_timeIn, p_timeOut, p_lunchStar, p_lunchEnd, p_check,p_BIn1, p_BOut1,p_BIn2, p_BOut2, p_IsB1, p_IsB2, p_userID, NOW(), p_userID, NOW(), 1, p_sun, p_mon, p_tue, p_wen, p_thu, p_fri, p_sat);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
