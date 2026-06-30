-- ─── PROCEDURE→FUNCTION: work_updateadminregularworkgroupdivisions_name ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateadminregularworkgroupdivisions_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkgroupdivisions_name(
    IN divisionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
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
