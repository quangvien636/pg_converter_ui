-- ─── PROCEDURE→FUNCTION: center_updateholidayforsaturdayandsunday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateholidayforsaturdayandsunday(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_updateholidayforsaturdayandsunday(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    holidayno integer;
BEGIN



	HolidayNo := (SELECT HolidayNo FROM Center_Holidays WHERE GroupNo = center_updateholidayforsaturdayandsunday.groupno AND HolidayType = 0);
	IF HolidayNo IS NULL THEN

		INSERT INTO Center_Holidays (ModUserNo, ModDate, GroupNo, HolidayType, HolidayDate, Lunar, Substitution, Title, Description)
		VALUES (ModUserNo, ModDate, GroupNo, 0, HolidayDate, '', '', '', '')

	END IF;

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
