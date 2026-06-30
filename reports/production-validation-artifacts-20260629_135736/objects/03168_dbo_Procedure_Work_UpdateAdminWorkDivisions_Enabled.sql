-- ─── PROCEDURE→FUNCTION: work_updateadminworkdivisions_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateadminworkdivisions_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateadminworkdivisions_enabled(
    IN divisionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN enabled boolean
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
