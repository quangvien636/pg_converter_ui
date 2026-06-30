-- ─── FUNCTION: note_getattactmentandshareforlistno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getattactmentandshareforlistno(uuid);
CREATE OR REPLACE FUNCTION public.note_getattactmentandshareforlistno(
    listno uuid
) RETURNS TABLE(
    col1 text,
    usersname text,
    usersnameen text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Note_Attactment
	WHERE ListNo=note_getattactmentandshareforlistno.listno
	ORDER BY IsAvatar DESC,DayCreate DESC

	RETURN QUERY
	SELECT  public."Note_Share".*, public."Organization_Users".Name AS UsersName, public."Organization_Users".Name_EN AS UsersNameEN
	FROM  public."Organization_Users" RIGHT OUTER JOIN
          public."Note_Share" ON public."Organization_Users".UserNo = public."Note_Share".UserShare
	WHERE ListNo=note_getattactmentandshareforlistno.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
