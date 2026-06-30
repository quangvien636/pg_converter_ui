-- ─── FUNCTION: work_getadminworkjournaldivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getadminworkjournaldivisions(integer);
CREATE OR REPLACE FUNCTION public.work_getadminworkjournaldivisions(
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
	FROM WorkJournalDivisions
	WHERE ParentNo = work_getadminworkjournaldivisions.parentno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
