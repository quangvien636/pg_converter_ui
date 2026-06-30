-- ─── FUNCTION: workingtime_savesetuppage ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_savesetuppage(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savesetuppage(
    p_page integer,
    p_h integer
) RETURNS void
AS $function$
BEGIN

	
	if((select count(1) from WorkingTime_setupPages) > 0)
		Begin;
				update WorkingTime_setupPages 
				set isPage = workingtime_savesetuppage.p_page, hidetime = workingtime_savesetuppage.p_h
		
		End
	else
		begin;
			insert into WorkingTime_setupPages(isPage, hidetime) values(p_page, p_h)
		end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
