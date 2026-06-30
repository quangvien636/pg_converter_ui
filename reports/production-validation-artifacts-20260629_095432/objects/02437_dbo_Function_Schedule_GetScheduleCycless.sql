-- ─── FUNCTION: schedule_getschedulecycless ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getschedulecycless();
CREATE OR REPLACE FUNCTION public.schedule_getschedulecycless(
) RETURNS TABLE(
    cycleno text,
    regdate text,
    name text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    sortorder text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT c.CycleNo
		, c.RegDate
		, c.Name
		, COALESCE(c.NameEn,c.Name) NameEn
		, COALESCE(c.NameJp,c.Name) NameJp
		, COALESCE(c.NameCh,c.Name) NameCh
		, COALESCE(c.NameVn,c.Name) NameVn
		, SortOrder
	FROM ScheduleCycles c order by c.SortOrder;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
