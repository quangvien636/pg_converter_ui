-- ─── PROCEDURE→FUNCTION: work_updateadminworkjournaldivisions_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateadminworkjournaldivisions_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateadminworkjournaldivisions_enabled(
    IN divisionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN



	UPDATE WorkJournalDivisions SET
		ModUserNo = work_updateadminworkjournaldivisions_enabled.moduserno,
		ModDate = work_updateadminworkjournaldivisions_enabled.moddate,
		Enabled = work_updateadminworkjournaldivisions_enabled.enabled
	WHERE DivisionNo = work_updateadminworkjournaldivisions_enabled.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
