-- ─── FUNCTION: work_updateadminworkjournaldivisions_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateadminworkjournaldivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminworkjournaldivisions_sortno(
    divisionno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkJournalDivisions SET
		ModUserNo = work_updateadminworkjournaldivisions_sortno.moduserno,
		ModDate = work_updateadminworkjournaldivisions_sortno.moddate,
		SortNo = work_updateadminworkjournaldivisions_sortno.sortno
	WHERE DivisionNo = work_updateadminworkjournaldivisions_sortno.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
