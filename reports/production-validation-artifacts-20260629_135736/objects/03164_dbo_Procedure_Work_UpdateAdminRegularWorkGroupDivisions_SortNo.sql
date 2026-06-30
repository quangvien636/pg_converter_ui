-- ─── PROCEDURE→FUNCTION: work_updateadminregularworkgroupdivisions_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateadminregularworkgroupdivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkgroupdivisions_sortno(
    IN divisionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
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
