-- ─── PROCEDURE→FUNCTION: center_deleteexclusionusersforipfilter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deleteexclusionusersforipfilter(bigint);
CREATE OR REPLACE FUNCTION public.center_deleteexclusionusersforipfilter(
    IN exclusionno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Center_ExclusionUsersForIPFilter
	WHERE ExclusionNo = center_deleteexclusionusersforipfilter.exclusionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
