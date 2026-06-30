-- ─── PROCEDURE→FUNCTION: workingtime_addcalculater ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_addcalculater(integer, integer, double precision, double precision, timestamp without time zone, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_addcalculater(
    IN p_uno integer,
    IN p_wkday integer,
    IN p_cin double precision,
    IN p_offset double precision,
    IN p_checkin timestamp without time zone,
    IN p_status integer,
    IN p_type integer DEFAULT 1,
    IN p_wkno integer DEFAULT 0,
    IN p_timelate integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	if(p_Type = 1 or p_Type = 2 )
		begin;
			INSERT INTO WorkingTime_Calculater(UserNo,WorkingDay,TimeCheckIn,Type,RegDate, WorkingNoRef, TimeLate, TimeOfset, CheckIn, Status)
			VALUES(p_Uno,p_Wkday,p_Cin,p_Type,NOW(), p_wkNo, p_timeLate, p_offset, p_CheckIn, p_Status)
		END;
	ELSE;
			INSERT INTO WorkingTime_Calculater(UserNo,WorkingDay,TimeCheckOut,typeOut,RegDate, WorkingNoRef, TimeLate, TimeOfset, CheckOut, StatusOut)
			VALUES(p_Uno,p_Wkday,p_Cin,p_Type,NOW(), p_wkNo, p_timeLate, p_offset, p_CheckIn, p_Status)
		END IF;
	if(p_Type = 1)
		begin;
		    	UPDATE WorkingTime_Calculater
				IsCheckIn := 1;
				WHERE Calculaterno=lastval()
		END;
	if(p_Type = 3)
		begin;
		    	UPDATE WorkingTime_Calculater
				IsCheckOut := 1;
				WHERE Calculaterno=lastval()
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
