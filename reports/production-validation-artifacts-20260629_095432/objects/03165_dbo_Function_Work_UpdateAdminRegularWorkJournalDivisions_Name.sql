-- ─── FUNCTION: work_updateadminregularworkjournaldivisions_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminregularworkjournaldivisions_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkjournaldivisions_name(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE RegularWorkJournalDivisions SET
		ModUserNo = work_updateadminregularworkjournaldivisions_name.moduserno,
		ModDate = work_updateadminregularworkjournaldivisions_name.moddate,
		Name = Name
	WHERE DivisionNo = work_updateadminregularworkjournaldivisions_name.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
