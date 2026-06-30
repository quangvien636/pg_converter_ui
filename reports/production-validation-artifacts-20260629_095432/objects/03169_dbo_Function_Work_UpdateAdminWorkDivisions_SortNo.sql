-- ─── FUNCTION: work_updateadminworkdivisions_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminworkdivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminworkdivisions_sortno(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
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
