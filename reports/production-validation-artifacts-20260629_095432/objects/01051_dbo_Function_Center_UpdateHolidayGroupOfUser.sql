-- ─── FUNCTION: center_updateholidaygroupofuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateholidaygroupofuser(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.center_updateholidaygroupofuser(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    groupno integer
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_HolidayGroupOfUsers WHERE UserNo = center_updateholidaygroupofuser.userno) = 0 BEGIN
	
		INSERT INTO Center_HolidayGroupOfUsers (UserNo, ModUserNo, ModDate, GroupNo)
		VALUES (UserNo, ModUserNo, ModDate, GroupNo)
	
	END

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
