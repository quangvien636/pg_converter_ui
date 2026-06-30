-- ─── PROCEDURE→FUNCTION: center_updateholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateholiday(integer, integer, timestamp without time zone, integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_updateholiday(
    IN holidayno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN holidaytype integer,
    IN holidaydate character varying,
    IN lunar character varying,
    IN substitution character varying,
    IN title character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_Holidays SET
		ModUserNo = center_updateholiday.moduserno,
		ModDate = center_updateholiday.moddate,
		HolidayType = center_updateholiday.holidaytype,
		HolidayDate = center_updateholiday.holidaydate,
		Lunar = center_updateholiday.lunar,
		Substitution = center_updateholiday.substitution,
		Title = center_updateholiday.title,
		Description = Description
	WHERE HolidayNo = center_updateholiday.holidayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
