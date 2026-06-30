-- ─── FUNCTION: workingtime_updatecalculater ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updatecalculater(integer, double precision, double precision, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updatecalculater(
    p_no integer,
    p_check double precision,
    p_time double precision,
    p_type integer,
    p_checkout timestamp without time zone,
    p_status integer
) RETURNS void
AS $function$
BEGIN

if(p_Type = 3 or p_Type = 4)
	begin;
		UPDATE WorkingTime_Calculater
		SET TimeCheckOut=workingtime_updatecalculater.p_check,
			TimeWork=workingtime_updatecalculater.p_time,
			typeOut=workingtime_updatecalculater.p_type
			,CheckOut = workingtime_updatecalculater.p_checkout  
			,StatusOut = workingtime_updatecalculater.p_status
		WHERE Calculaterno=workingtime_updatecalculater.p_no
	end
	
	if(p_Type = 1 or p_Type = 2)
		begin;
			UPDATE WorkingTime_Calculater
			SET TimeCheckIn=workingtime_updatecalculater.p_check,
				TimeWork=workingtime_updatecalculater.p_time
				,type=workingtime_updatecalculater.p_type
				,CheckIn = workingtime_updatecalculater.p_checkout  
				,Status = workingtime_updatecalculater.p_status
			WHERE Calculaterno=workingtime_updatecalculater.p_no
		end
	if(p_Type =3)
		begin ;
				UPDATE WorkingTime_Calculater
				SET IsCheckOut = TRUE
				WHERE Calculaterno=workingtime_updatecalculater.p_no
		end
	if(p_Type = 1)
	begin;
		    UPDATE WorkingTime_Calculater
			SET IsCheckIn = TRUE
			WHERE Calculaterno=workingtime_updatecalculater.p_no
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
