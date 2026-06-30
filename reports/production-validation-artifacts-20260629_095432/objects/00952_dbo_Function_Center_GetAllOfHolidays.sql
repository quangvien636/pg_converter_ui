-- ─── FUNCTION: center_getallofholidays ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getallofholidays(integer);
CREATE OR REPLACE FUNCTION public.center_getallofholidays(
    groupno integer
) RETURNS TABLE(
    holidayno text,
    moduserno text,
    moddate text,
    holidaytype text,
    holidaydate text,
    lunar text,
    substitution text,
    title text,
    description text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT HolidayNo, ModUserNo, ModDate, HolidayType, HolidayDate, Lunar, Substitution, Title, Description
	FROM Center_Holidays
	WHERE GroupNo = center_getallofholidays.groupno
	ORDER BY HolidayType ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
