-- ─── FUNCTION: work_updateadminregularworkgroupdivisions_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminregularworkgroupdivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkgroupdivisions_sortno(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE RegularWorkGroupDivisions SET
		ModUserNo = work_updateadminregularworkgroupdivisions_sortno.moduserno,
		ModDate = work_updateadminregularworkgroupdivisions_sortno.moddate,
		SortNo = work_updateadminregularworkgroupdivisions_sortno.sortno
	WHERE DivisionNo = work_updateadminregularworkgroupdivisions_sortno.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
