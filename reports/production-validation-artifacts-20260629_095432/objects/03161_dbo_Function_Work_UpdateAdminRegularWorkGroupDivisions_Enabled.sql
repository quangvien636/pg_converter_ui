-- ─── FUNCTION: work_updateadminregularworkgroupdivisions_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminregularworkgroupdivisions_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkgroupdivisions_enabled(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN



	UPDATE RegularWorkGroupDivisions SET
		ModUserNo = work_updateadminregularworkgroupdivisions_enabled.moduserno,
		ModDate = work_updateadminregularworkgroupdivisions_enabled.moddate,
		Enabled = work_updateadminregularworkgroupdivisions_enabled.enabled
	WHERE DivisionNo = work_updateadminregularworkgroupdivisions_enabled.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
