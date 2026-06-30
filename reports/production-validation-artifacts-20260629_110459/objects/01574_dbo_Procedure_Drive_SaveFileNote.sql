-- ─── PROCEDURE→FUNCTION: drive_savefilenote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.drive_savefilenote(integer);
CREATE OR REPLACE FUNCTION public.drive_savefilenote(
    IN p_fno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Drive_Files SET NOTE = p_Note WHERE FILENO = drive_savefilenote.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
