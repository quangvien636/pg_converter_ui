-- ─── FUNCTION: work_updateadminregularworkjournaldivisions_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminregularworkjournaldivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkjournaldivisions_sortno(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE RegularWorkJournalDivisions SET
		ModUserNo = work_updateadminregularworkjournaldivisions_sortno.moduserno,
		ModDate = work_updateadminregularworkjournaldivisions_sortno.moddate,
		SortNo = work_updateadminregularworkjournaldivisions_sortno.sortno
	WHERE DivisionNo = work_updateadminregularworkjournaldivisions_sortno.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
