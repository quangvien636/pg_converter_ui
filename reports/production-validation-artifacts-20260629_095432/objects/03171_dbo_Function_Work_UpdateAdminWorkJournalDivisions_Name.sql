-- ─── FUNCTION: work_updateadminworkjournaldivisions_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminworkjournaldivisions_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updateadminworkjournaldivisions_name(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkJournalDivisions SET
		ModUserNo = work_updateadminworkjournaldivisions_name.moduserno,
		ModDate = work_updateadminworkjournaldivisions_name.moddate,
		Name = Name
	WHERE DivisionNo = work_updateadminworkjournaldivisions_name.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
