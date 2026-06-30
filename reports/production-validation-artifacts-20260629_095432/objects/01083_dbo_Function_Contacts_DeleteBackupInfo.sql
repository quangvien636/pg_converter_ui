-- ─── FUNCTION: contacts_deletebackupinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_deletebackupinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_deletebackupinfo(
    backupno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ContactsBackup WHERE BackupNo = contacts_deletebackupinfo.backupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
