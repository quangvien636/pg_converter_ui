-- ─── FUNCTION: center_insertexclusionusersforipfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertexclusionusersforipfilter(date, date, boolean, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertexclusionusersforipfilter(
    startdate date,
    enddate date,
    allow boolean,
    sortno integer,
    userno integer DEFAULT 0,
    departno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Center_ExclusionUsersForIPFilter
	(UserNo,DepartNo,StartDate,EndDate,Allow,SortNo)
	VALUES(UserNo,DepartNo,StartDate,EndDate,Allow,SortNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
