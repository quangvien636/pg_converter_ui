-- ─── FUNCTION: center_insertholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertholiday(integer, timestamp without time zone, integer, integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertholiday(
    moduserno integer,
    moddate timestamp without time zone,
    groupno integer,
    holidaytype integer,
    holidaydate character varying,
    lunar character varying,
    substitution character varying,
    title character varying
) RETURNS void
AS $function$
DECLARE
    holidayno integer;
BEGIN


	INSERT INTO Center_Holidays (ModUserNo, ModDate, GroupNo, HolidayType, HolidayDate, Lunar, Substitution, Title, Description)
	VALUES (ModUserNo, ModDate, GroupNo, HolidayType, HolidayDate, Lunar, Substitution, Title, Description);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
