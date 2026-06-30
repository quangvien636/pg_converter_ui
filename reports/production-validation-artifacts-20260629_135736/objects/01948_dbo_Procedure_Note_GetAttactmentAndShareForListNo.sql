-- ─── PROCEDURE→FUNCTION: note_getattactmentandshareforlistno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getattactmentandshareforlistno(uuid);
CREATE OR REPLACE FUNCTION public.note_getattactmentandshareforlistno(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
