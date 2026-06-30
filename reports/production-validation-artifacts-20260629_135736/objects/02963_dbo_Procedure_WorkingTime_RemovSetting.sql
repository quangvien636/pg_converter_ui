-- ─── PROCEDURE→FUNCTION: workingtime_removsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_removsetting(integer);
CREATE OR REPLACE FUNCTION public.workingtime_removsetting(
    IN p_uid integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	GroupId := NULL;
	WHERE UserNo = workingtime_removsetting.p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
