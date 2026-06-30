-- ─── PROCEDURE→FUNCTION: workingtime_savemove ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_savemove(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savemove(
    IN p_uid integer,
    IN p_id integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	GroupId := workingtime_savemove.p_id;
	WHERE UserNo = workingtime_savemove.p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
