-- ─── PROCEDURE→FUNCTION: note_getattachmentandshareforlistno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getattachmentandshareforlistno(uuid);
CREATE OR REPLACE FUNCTION public.note_getattachmentandshareforlistno(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT * FROM Note_Attachment
	WHERE ListNo = note_getattachmentandshareforlistno.listno
	ORDER BY IsAvatar DESC, DayCreate DESC

	RETURN QUERY
	SELECT Note_Share.*, Organization_Users.Name AS UsersName, Organization_Users.Name_EN AS UsersNameEN
	FROM Organization_Users
	RIGHT OUTER JOIN Note_Share ON Organization_Users.UserNo = Note_Share.UserShare
	WHERE ListNo = note_getattachmentandshareforlistno.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
