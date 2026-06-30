-- ─── PROCEDURE→FUNCTION: center_insertholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertholiday(integer, timestamp without time zone, integer, integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertholiday(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno integer,
    IN holidaytype integer,
    IN holidaydate character varying,
    IN lunar character varying,
    IN substitution character varying,
    IN title character varying
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
