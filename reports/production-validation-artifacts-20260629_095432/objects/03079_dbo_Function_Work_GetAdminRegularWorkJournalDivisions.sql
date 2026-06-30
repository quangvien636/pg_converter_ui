-- ─── FUNCTION: work_getadminregularworkjournaldivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getadminregularworkjournaldivisions(integer);
CREATE OR REPLACE FUNCTION public.work_getadminregularworkjournaldivisions(
    parentno integer
) RETURNS TABLE(
    divisionno serial,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    sortno integer,
    enabled boolean
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM RegularWorkJournalDivisions
	WHERE ParentNo = work_getadminregularworkjournaldivisions.parentno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
