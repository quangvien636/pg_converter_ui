-- ─── FUNCTION: work_getadminregularworkgroupdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getadminregularworkgroupdivisions();
CREATE OR REPLACE FUNCTION public.work_getadminregularworkgroupdivisions(
) RETURNS TABLE(
    divisionno serial,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying(100),
    sortno integer,
    enabled boolean
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM RegularWorkGroupDivisions
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
