-- ─── FUNCTION: workingtime_addsettinggroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_addsettinggroup(character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_addsettinggroup(
    p_name character varying,
    p_timein character varying,
    p_timeout character varying,
    p_lunchstar character varying,
    p_lunchend character varying,
    p_check boolean,
    p_bin1 character varying,
    p_bout1 character varying,
    p_bin2 character varying,
    p_bout2 character varying,
    p_isb1 character varying,
    p_isb2 character varying,
    p_userid integer,
    p_sun integer,
    p_mon integer,
    p_tue integer,
    p_wen integer,
    p_thu integer,
    p_fri integer,
    p_sat integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WorkingTime_SettingGroup(Name, TimeIn, TimeOut, LunchStart, LunchEnd, IsAddLunch,BIn1, BOut1,BIn2, BOut2, IsB1, IsB2, RegisteredId, RegisteredDate, UpdateId, UpdatedDate, Statust, Sun, Mon, Tue, Wen, Thur, Fri, Sat)
	values(p_Name,p_timeIn, p_timeOut, p_lunchStar, p_lunchEnd, p_check,p_BIn1, p_BOut1,p_BIn2, p_BOut2, p_IsB1, p_IsB2, p_userID, NOW(), p_userID, NOW(), 1, p_sun, p_mon, p_tue, p_wen, p_thu, p_fri, p_sat);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
