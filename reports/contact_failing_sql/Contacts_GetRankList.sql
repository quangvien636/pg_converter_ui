-- ─── PROCEDURE→FUNCTION: contacts_getranklist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getranklist(integer);
CREATE OR REPLACE FUNCTION public.contacts_getranklist(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT RowNum, LIMIT 10
		Seq,
		FirstName,
		LastName,
		Memo,
		ViewCount
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY ViewCount DESC) AS RowNum,
			U.Seq,
			U.FirstName,
			U.LastName,
			U.Memo,
			U.ViewCount
		  FROM ContactsUser U
		  JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
		WHERE U.RegUserNo = contacts_getranklist.userno
		AND UseYn = 'Y'
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.