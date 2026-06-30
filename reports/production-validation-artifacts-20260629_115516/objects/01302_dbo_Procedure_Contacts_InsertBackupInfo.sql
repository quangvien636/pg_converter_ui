-- ─── PROCEDURE→FUNCTION: contacts_insertbackupinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertbackupinfo(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_insertbackupinfo(
    IN userno integer,
    IN contactcnt integer,
    IN groupcnt integer,
    IN memo character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	INSERT INTO ContactsBackup (UserNo, ContactCnt, GroupCnt, Memo, RegDate, Path)
	VALUES (UserNo, ContactCnt, GroupCnt, Memo, NOW(), FullPath)
	
	RETURN QUERY
	SELECT COUNT(*) FROM ContactsBackup WHERE UserNo=contacts_insertbackupinfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
