-- ─── PROCEDURE→FUNCTION: work_updateadminregularworkjournaldivisions_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateadminregularworkjournaldivisions_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.work_updateadminregularworkjournaldivisions_sortno(
    IN divisionno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
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
