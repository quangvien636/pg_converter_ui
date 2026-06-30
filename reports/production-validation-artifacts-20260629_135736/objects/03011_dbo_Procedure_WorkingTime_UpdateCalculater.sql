-- ─── PROCEDURE→FUNCTION: workingtime_updatecalculater ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updatecalculater(integer, double precision, double precision, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updatecalculater(
    IN p_no integer,
    IN p_check double precision,
    IN p_time double precision,
    IN p_type integer,
    IN p_checkout timestamp without time zone,
    IN p_status integer
) RETURNS void
AS $function$
BEGIN

if(p_Type = 3 or p_Type = 4)
	begin;
		UPDATE WorkingTime_Calculater
		TimeCheckOut := workingtime_updatecalculater.p_check,;
			TimeWork=workingtime_updatecalculater.p_time,
			typeOut=workingtime_updatecalculater.p_type
			,CheckOut = workingtime_updatecalculater.p_checkout  
			,StatusOut = workingtime_updatecalculater.p_status
		WHERE Calculaterno=workingtime_updatecalculater.p_no
	END;
	
	if(p_Type = 1 or p_Type = 2)
		begin;
			UPDATE WorkingTime_Calculater
			TimeCheckIn := workingtime_updatecalculater.p_check,;
				TimeWork=workingtime_updatecalculater.p_time
				,type=workingtime_updatecalculater.p_type
				,CheckIn = workingtime_updatecalculater.p_checkout  
				,Status = workingtime_updatecalculater.p_status
			WHERE Calculaterno=workingtime_updatecalculater.p_no
		END;
	if(p_Type =3)
		begin ;
				UPDATE WorkingTime_Calculater
				IsCheckOut := 1;
				WHERE Calculaterno=workingtime_updatecalculater.p_no
		END;
	if(p_Type = 1)
	begin;
		    UPDATE WorkingTime_Calculater
			IsCheckIn := 1;
			WHERE Calculaterno=workingtime_updatecalculater.p_no
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
