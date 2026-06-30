-- ─── PROCEDURE→FUNCTION: work_updateadminworkdivisions_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateadminworkdivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminworkdivisions_sortno(
    IN divisionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkDivisions SET
		ModUserNo = work_updateadminworkdivisions_sortno.moduserno,
		ModDate = work_updateadminworkdivisions_sortno.moddate,
		SortNo = work_updateadminworkdivisions_sortno.sortno
	WHERE DivisionNo = work_updateadminworkdivisions_sortno.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
