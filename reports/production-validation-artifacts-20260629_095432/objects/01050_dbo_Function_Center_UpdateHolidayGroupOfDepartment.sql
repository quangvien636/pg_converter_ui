-- ─── FUNCTION: center_updateholidaygroupofdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateholidaygroupofdepartment(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.center_updateholidaygroupofdepartment(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone,
    groupno integer
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_HolidayGroupOfDepartments WHERE DepartNo = center_updateholidaygroupofdepartment.departno) = 0 BEGIN
	
		INSERT INTO Center_HolidayGroupOfDepartments (DepartNo, ModUserNo, ModDate, GroupNo)
		VALUES (DepartNo, ModUserNo, ModDate, GroupNo)
	
	END

	ELSE BEGIN
	
		UPDATE Center_HolidayGroupOfDepartments SET
			ModUserNo = center_updateholidaygroupofdepartment.moduserno,
			ModDate = center_updateholidaygroupofdepartment.moddate,
			GroupNo = center_updateholidaygroupofdepartment.groupno
		WHERE DepartNo = center_updateholidaygroupofdepartment.departno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
