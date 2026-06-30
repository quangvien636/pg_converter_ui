-- ─── PROCEDURE→FUNCTION: drive_savefoldernote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.drive_savefoldernote(integer);
CREATE OR REPLACE FUNCTION public.drive_savefoldernote(
    IN p_fno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Drive_Folders  SET NOTE = p_Note WHERE FOLDERNO = drive_savefoldernote.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
