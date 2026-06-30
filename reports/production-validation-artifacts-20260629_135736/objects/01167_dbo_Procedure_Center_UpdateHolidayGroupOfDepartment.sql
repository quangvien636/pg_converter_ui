-- ─── PROCEDURE→FUNCTION: center_updateholidaygroupofdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateholidaygroupofdepartment(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.center_updateholidaygroupofdepartment(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno integer
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_HolidayGroupOfDepartments WHERE DepartNo = center_updateholidaygroupofdepartment.departno) = 0 THEN
	
		INSERT INTO Center_HolidayGroupOfDepartments (DepartNo, ModUserNo, ModDate, GroupNo)
		VALUES (DepartNo, ModUserNo, ModDate, GroupNo)
	
	END IF;

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
