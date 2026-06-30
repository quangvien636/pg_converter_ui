-- ─── PROCEDURE→FUNCTION: contacts_deletebackupinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_deletebackupinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_deletebackupinfo(
    IN backupno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ContactsBackup WHERE BackupNo = contacts_deletebackupinfo.backupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
