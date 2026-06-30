-- ─── FUNCTION: workingtime_updateworkingtimelocation ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimelocation(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimelocation(
    p_locationno integer,
    p_type integer,
    p_wid integer
) RETURNS void
AS $function$
BEGIN

	if(p_type = 2 Or p_type = 4 )
		begin;
			UPDATE WorkingTime_Times 
			SET NameCompany = (select Name from WorkingTime_LocationsOutside o where o.LocationNo = workingtime_updateworkingtimelocation.p_locationno)
			WHERE WorkingNo = workingtime_updateworkingtimelocation.p_wid
		end
	else 
		begin;
			UPDATE WorkingTime_Times 
			SET NameCompany = (select Name from WorkingTime_Locations l where l.LocationNo = workingtime_updateworkingtimelocation.p_locationno)
			WHERE WorkingNo = workingtime_updateworkingtimelocation.p_wid
		end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
