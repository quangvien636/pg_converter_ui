-- ─── FUNCTION: contacts_getbackupinfoonce ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getbackupinfoonce(integer);
CREATE OR REPLACE FUNCTION public.contacts_getbackupinfoonce(
    backupno integer
) RETURNS TABLE(
    backupno text,
    userno text,
    contactcnt text,
    groupcnt text,
    memo text,
    regdate text,
    path text,
    type text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT BackupNo, UserNo, ContactCnt, GroupCnt, Memo, RegDate, Path, TYPE
	FROM ContactsBackup WHERE BackupNo=contacts_getbackupinfoonce.backupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
