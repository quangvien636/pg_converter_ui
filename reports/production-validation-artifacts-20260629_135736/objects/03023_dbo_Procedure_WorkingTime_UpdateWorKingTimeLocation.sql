-- ─── PROCEDURE→FUNCTION: workingtime_updateworkingtimelocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimelocation(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimelocation(
    IN p_locationno integer,
    IN p_type integer,
    IN p_wid integer
) RETURNS void
AS $function$
BEGIN

	if(p_type = 2 Or p_type = 4 )
		begin;
			UPDATE WorkingTime_Times 
			NameCompany := (select Name from WorkingTime_LocationsOutside o where o.LocationNo = workingtime_updateworkingtimelocation.p_locationno);
			WHERE WorkingNo = workingtime_updateworkingtimelocation.p_wid
		END;
	ELSE;
			UPDATE WorkingTime_Times 
			NameCompany := (select Name from WorkingTime_Locations l where l.LocationNo = workingtime_updateworkingtimelocation.p_locationno);
			WHERE WorkingNo = workingtime_updateworkingtimelocation.p_wid
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
