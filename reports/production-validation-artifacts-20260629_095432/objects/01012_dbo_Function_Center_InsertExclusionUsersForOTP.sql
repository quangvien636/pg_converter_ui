-- ─── FUNCTION: center_insertexclusionusersforotp ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertexclusionusersforotp(date, date, boolean, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertexclusionusersforotp(
    startdate date,
    enddate date,
    allow boolean,
    sortno integer,
    userno integer DEFAULT 0,
    departno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Center_ExclusionUsersForOTP
	(UserNo,DepartNo,StartDate,EndDate,Allow,SortNo)
	VALUES(UserNo,DepartNo,StartDate,EndDate,Allow,SortNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
