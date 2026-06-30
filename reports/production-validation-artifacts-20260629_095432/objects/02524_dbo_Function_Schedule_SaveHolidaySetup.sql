-- ─── FUNCTION: schedule_saveholidaysetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_saveholidaysetup(boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_saveholidaysetup(
    p_show boolean,
    p_url character varying
) RETURNS void
AS $function$
BEGIN
 

if((select count(1) from HolidaySetup) = 0)
	begin;
		INSERT INTO HolidaySetup(SHOW,URL,KEY) VALUES (p_show, p_Url,p_Key)
	end
else
	begin;
		UPDATE HolidaySetup SET SHOW = schedule_saveholidaysetup.p_show, URL = schedule_saveholidaysetup.p_url, KEY = p_Key
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
