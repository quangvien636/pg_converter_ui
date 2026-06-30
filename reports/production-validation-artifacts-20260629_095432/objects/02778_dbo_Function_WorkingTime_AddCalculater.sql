-- ─── FUNCTION: workingtime_addcalculater ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_addcalculater(integer, integer, double precision, double precision, timestamp without time zone, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_addcalculater(
    p_uno integer,
    p_wkday integer,
    p_cin double precision,
    p_offset double precision,
    p_checkin timestamp without time zone,
    p_status integer,
    p_type integer DEFAULT 1,
    p_wkno integer DEFAULT 0,
    p_timelate integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	if(p_Type = 1 or p_Type = 2 )
		begin;
			INSERT INTO WorkingTime_Calculater(UserNo,WorkingDay,TimeCheckIn,Type,RegDate, WorkingNoRef, TimeLate, TimeOfset, CheckIn, Status)
			VALUES(p_Uno,p_Wkday,p_Cin,p_Type,NOW(), p_wkNo, p_timeLate, p_offset, p_CheckIn, p_Status)
		end
	else
		begin;
			INSERT INTO WorkingTime_Calculater(UserNo,WorkingDay,TimeCheckOut,typeOut,RegDate, WorkingNoRef, TimeLate, TimeOfset, CheckOut, StatusOut)
			VALUES(p_Uno,p_Wkday,p_Cin,p_Type,NOW(), p_wkNo, p_timeLate, p_offset, p_CheckIn, p_Status)
		end
	if(p_Type = 1)
		begin;
		    	UPDATE WorkingTime_Calculater
				SET IsCheckIn = TRUE
				WHERE Calculaterno=lastval()
		end
	if(p_Type = 3)
		begin;
		    	UPDATE WorkingTime_Calculater
				SET IsCheckOut = TRUE
				WHERE Calculaterno=lastval()
		end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
