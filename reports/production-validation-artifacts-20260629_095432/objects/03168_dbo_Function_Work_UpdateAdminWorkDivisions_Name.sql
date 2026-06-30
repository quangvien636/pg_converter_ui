-- ─── FUNCTION: work_updateadminworkdivisions_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminworkdivisions_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updateadminworkdivisions_name(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkDivisions SET
		ModUserNo = work_updateadminworkdivisions_name.moduserno,
		ModDate = work_updateadminworkdivisions_name.moddate,
		Name = Name
	WHERE DivisionNo = work_updateadminworkdivisions_name.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
