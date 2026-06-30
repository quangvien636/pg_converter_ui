-- ─── PROCEDURE→FUNCTION: workingtime_savesetuppage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_savesetuppage(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savesetuppage(
    IN p_page integer,
    IN p_h integer
) RETURNS void
AS $function$
BEGIN

	
	if((select count(1) from WorkingTime_setupPages) > 0)
		Begin;
				update WorkingTime_setupPages 
				isPage := workingtime_savesetuppage.p_page, hidetime = workingtime_savesetuppage.p_h;
		END;
	ELSE;
			insert into WorkingTime_setupPages(isPage, hidetime) values(p_page, p_h)
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
