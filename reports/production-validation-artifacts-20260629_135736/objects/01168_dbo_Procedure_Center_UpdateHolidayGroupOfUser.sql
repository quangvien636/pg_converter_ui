-- ─── PROCEDURE→FUNCTION: center_updateholidaygroupofuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateholidaygroupofuser(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.center_updateholidaygroupofuser(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno integer
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_HolidayGroupOfUsers WHERE UserNo = center_updateholidaygroupofuser.userno) = 0 THEN
	
		INSERT INTO Center_HolidayGroupOfUsers (UserNo, ModUserNo, ModDate, GroupNo)
		VALUES (UserNo, ModUserNo, ModDate, GroupNo)
	
	END IF;

	ELSE BEGIN
	
		UPDATE Center_HolidayGroupOfUsers SET
			ModUserNo = center_updateholidaygroupofuser.moduserno,
			ModDate = center_updateholidaygroupofuser.moddate,
			GroupNo = center_updateholidaygroupofuser.groupno
		WHERE UserNo = center_updateholidaygroupofuser.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
