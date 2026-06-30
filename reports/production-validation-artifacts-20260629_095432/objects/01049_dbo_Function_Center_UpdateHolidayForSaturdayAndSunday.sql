-- ─── FUNCTION: center_updateholidayforsaturdayandsunday ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateholidayforsaturdayandsunday(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_updateholidayforsaturdayandsunday(
    groupno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    holidayno integer;
BEGIN



	SET HolidayNo = (SELECT HolidayNo FROM Center_Holidays WHERE GroupNo = center_updateholidayforsaturdayandsunday.groupno AND HolidayType = 0)

	IF (HolidayNo IS NULL) BEGIN

		INSERT INTO Center_Holidays (ModUserNo, ModDate, GroupNo, HolidayType, HolidayDate, Lunar, Substitution, Title, Description)
		VALUES (ModUserNo, ModDate, GroupNo, 0, HolidayDate, '', '', '', '')

	END

	ELSE BEGIN
	
		UPDATE Center_Holidays SET
			ModUserNo = center_updateholidayforsaturdayandsunday.moduserno,
			ModDate = center_updateholidayforsaturdayandsunday.moddate,
			HolidayDate = HolidayDate
		WHERE HolidayNo = HolidayNo

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
