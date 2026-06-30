-- ─── FUNCTION: work_updateadminregularworkgroupdivisions_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminregularworkgroupdivisions_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkgroupdivisions_name(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE RegularWorkGroupDivisions SET
		ModUserNo = work_updateadminregularworkgroupdivisions_name.moduserno,
		ModDate = work_updateadminregularworkgroupdivisions_name.moddate,
		Name = Name
	WHERE DivisionNo = work_updateadminregularworkgroupdivisions_name.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
