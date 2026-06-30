-- ─── FUNCTION: contacts_getbackupinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getbackupinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_getbackupinfo(
    userno integer
) RETURNS TABLE(
    backupno serial,
    userno integer,
    contactcnt integer,
    groupcnt integer,
    memo character varying(500),
    regdate timestamp without time zone,
    path character varying(1000),
    type integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsBackup WHERE UserNo = contacts_getbackupinfo.userno
	ORDER BY RegDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
