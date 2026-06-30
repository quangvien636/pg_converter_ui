-- ─── FUNCTION: work_updateadminworkdivisions_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminworkdivisions_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateadminworkdivisions_enabled(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN



	UPDATE WorkDivisions SET
		ModUserNo = work_updateadminworkdivisions_enabled.moduserno,
		ModDate = work_updateadminworkdivisions_enabled.moddate,
		Enabled = work_updateadminworkdivisions_enabled.enabled
	WHERE DivisionNo = work_updateadminworkdivisions_enabled.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
