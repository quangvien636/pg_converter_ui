-- ─── FUNCTION: work_updateadminregularworkjournaldivisions_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminregularworkjournaldivisions_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkjournaldivisions_enabled(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN



	UPDATE RegularWorkJournalDivisions SET
		ModUserNo = work_updateadminregularworkjournaldivisions_enabled.moduserno,
		ModDate = work_updateadminregularworkjournaldivisions_enabled.moddate,
		Enabled = work_updateadminregularworkjournaldivisions_enabled.enabled
	WHERE DivisionNo = work_updateadminregularworkjournaldivisions_enabled.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
