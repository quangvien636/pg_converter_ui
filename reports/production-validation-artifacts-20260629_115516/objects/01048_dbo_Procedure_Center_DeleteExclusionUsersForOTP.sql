-- ─── PROCEDURE→FUNCTION: center_deleteexclusionusersforotp ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deleteexclusionusersforotp(bigint);
CREATE OR REPLACE FUNCTION public.center_deleteexclusionusersforotp(
    IN exclusionno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Center_ExclusionUsersForOTP
	WHERE ExclusionNo = center_deleteexclusionusersforotp.exclusionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
