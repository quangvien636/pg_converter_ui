-- ─── FUNCTION: contacts_insertbackupinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertbackupinfo(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_insertbackupinfo(
    userno integer,
    contactcnt integer,
    groupcnt integer,
    memo character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	INSERT INTO ContactsBackup (UserNo, ContactCnt, GroupCnt, Memo, RegDate, Path)
	VALUES (UserNo, ContactCnt, GroupCnt, Memo, NOW(), FullPath)
	
	RETURN QUERY
	SELECT COUNT(*) FROM ContactsBackup WHERE UserNo=contacts_insertbackupinfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
