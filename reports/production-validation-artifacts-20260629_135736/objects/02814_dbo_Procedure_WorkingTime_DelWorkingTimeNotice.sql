-- ─── PROCEDURE→FUNCTION: workingtime_delworkingtimenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_delworkingtimenotice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_delworkingtimenotice(
    IN noticeno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_Notices WHERE NoticeNo = workingtime_delworkingtimenotice.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
