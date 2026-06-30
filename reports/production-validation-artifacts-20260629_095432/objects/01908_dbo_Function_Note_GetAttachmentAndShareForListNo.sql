-- ─── FUNCTION: note_getattachmentandshareforlistno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getattachmentandshareforlistno(uuid);
CREATE OR REPLACE FUNCTION public.note_getattachmentandshareforlistno(
    listno uuid
) RETURNS TABLE(
    col1 text,
    usersname text,
    usersnameen text
)
AS $function$
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
