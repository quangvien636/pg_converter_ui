-- ─── PROCEDURE→FUNCTION: center_insertexclusionusersforotp ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertexclusionusersforotp(date, date, boolean, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertexclusionusersforotp(
    IN startdate date,
    IN enddate date,
    IN allow boolean,
    IN sortno integer,
    IN userno integer DEFAULT 0,
    IN departno integer DEFAULT 0
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
