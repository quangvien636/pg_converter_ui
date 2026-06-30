-- ─── PROCEDURE→FUNCTION: center_insertexclusionusersforipfilter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertexclusionusersforipfilter(date, date, boolean, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertexclusionusersforipfilter(
    IN startdate date,
    IN enddate date,
    IN allow boolean,
    IN sortno integer,
    IN userno integer DEFAULT 0,
    IN departno integer DEFAULT 0
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
